'use strict'

passport = require 'passport'
auth = require './auth'
mongo = require './database/mongo'
wechat = require 'wechat'
API = require 'wechat-api'
appid = 'wx1f9fe13fd3655a8d'
secret = '2a3792094fc7e3b91a4920a8afb0a0c1'
Token = require('../models').Token
User = require('../models').User
LotteryRecord = require('../models').LotteryRecord
logger = require('log4js').getDefaultLogger()
EventProxy = require 'eventproxy'
sms = require '../lib/sms'

getToken = (cb)->
  Token.findOne appid:appid, (err, result)->
    if err
      logger.error 'GetTokenError:'+err
      cb null, null
    else if result
      if(new Date().getTime()-result.get_ts.getTime() < 300000)
        cb null, accessToken:result.token
      else
        cb null, null
    else
      cb null, null

saveToken = (token, cb)->
  Token.findOne appid:appid, (err, result)->
    if err
      cb null, null
      logger.error 'SaveTokenError:'+err
    else if result && result.token
      result.token = token.accessToken
      result.get_ts = new Date()
      result.save cb
    else
      token = new Token(
        appid:appid
        secret:secret
        token:token.accessToken
        get_ts:new Date()
      )
      token.save cb

api = new API(appid, secret, getToken, saveToken)

initUser = (openid, callback)->
  User.findOne openid:openid, (err, result)->
    if err
      logger.error err
      callback err
    else if result
      logger.trace 'UserInfoGot:'+JSON.stringify(result)
      callback null, result
    else
      api.getUser openid, (err, result)->
        logger.trace 'UserInfoInited:'+JSON.stringify(result)
        if !err
          user = new User(result)
          user.created_at = new Date()
          user.save callback
        else
          callback err

module.exports = (app)->

  app.on 'middleware:after:session', (args)->
    passport.use(auth.localStrategy())
    app.use(passport.initialize())
    app.use(passport.session())
    app.use(auth.injectUser())
    app.use (req, res, next)->
      ua = req.headers['user-agent']
      path = req.path
      onlyMobile = ['/auto_init', '/init', '/draw_lottery', '/share_lottery']
      if onlyMobile.indexOf(path) != -1
        if (/mobile/i.test(ua))
          next()
        else
          res.send '仅支持微信浏览'
      else
        next()
    passport.serializeUser(auth.serialize)
    passport.deserializeUser(auth.deserialize)

  config =
    token:'wechat'
    appid:appid
    encodingAESKey:'YN8K5TKe0aY2fBmYGKHPpDNxu4TRnD7hSyt8wVwb3dw'

  reply1 = (res)->
    s = '欢迎关注润石创投服务号，我们将竭诚为您服务！\n客服电话：400-690-8862\n官方网址：<a href="http://www.rsct.com">www.rsct.com</a>'
    res.reply s

  app.use('/wechat', wechat(config, (req, res, next)->
      message = req.weixin

      wxmessage = JSON.stringify(message)
      logger.trace('WXM:'+wxmessage)

      content = message.Content

      if message.Event == 'subscribe'
        initUser message.FromUserName, (err, result)->
          reply1 res
      else
        openid = message.FromUserName
        wxsession = {}
        User.findOne openid:openid, (err, result)->
          if err
            logger.error 'FindUserError:'+err
            res.reply '系统出错，请稍候再试'
          else if result
            user = result
            if content == '领取'
              q = openid:openid,status:true,dispatched:false
              LotteryRecord.find(q).populate('lottery', 'name').exec (err, result)->
                if err
                  logger.error 'FindLRError:'+err
                  res.reply '系统出错，请稍候再试'
                else if result && result.length
                  wxsession.lid = result[0]._id
                  wxsession.input_address = true
                  s = '系统查询到您中了以下活动的奖品：\n'
                  result.forEach (r)->
                    s+= r.lottery.name+'\n'
                  info = user.truename+' '+user.mobile2+' '+user.address
                  if user.address
                    s += '\n 系统查询到您曾使用过收货信息为：\n'+info+'\n 如果继续使用该地址请回复Y，重新输入请回复N'
                    wxsession.userinfo = info
                    wxsession.hasAddress = true
                  else
                    s += '请输入您的收件人姓名、手机号码和收件地址，我们将会尽快为您派发奖品（以空格隔开，如：收件人 手机号码 收货地址）'
                  user.wx_status = JSON.stringify(wxsession)
                  user.save (err, result)->
                    if err
                      logger.error 'wx_status save error:'+err
                      res.reply '系统出错，请稍候再试'
                    else
                      res.reply s
                else
                  res.reply '未查询到中奖结果，请您关注并参与其它抽奖活动，感谢您的对润石创投的支持！'
            else
              wxsession = JSON.parse(user.wx_status) if user.wx_status
              lid = wxsession.lid
              if content && wxsession.input_address
                ep = new EventProxy()
                saveInfo = (truename, address, mobile)->
                  truename = '' unless truename
                  address = '' unless address
                  mobile = '' unless mobile
                  if !truename || !address || !mobile
                    res.reply '收件人姓名、地址或手机号不能为空'
                  else
                    ep.on 'lr', ->
                      wxsession.input_address = false
                      user.wx_status = JSON.stringify(wxsession)
                      user.truename = truename
                      user.address = address
                      user.mobile2 = mobile
                      user.save (err, result)->
                        if err
                          logger.error 'SavewxStatusE1:'+err
                          res.reply '抱歉，系统出错，请稍候再试'
                        else
                          console.log JSON.stringify(result)
                          res.reply '信息已经提交成功，我们会尽快为您派发奖品，请耐心等待'

                    ep.fail (err)->
                      logger.error 'SaveAddressError:'+err
                      res.reply '抱歉，系统出错，请稍候再试'

                    LotteryRecord.findByIdAndUpdate lid, $set:truename:truename,address:address,mobile:mobile, ep.done 'lr'
#                    User.findOneAndUpdate openid, $set:truename:truename,address:address,mobile2:mobile, ep.done 'user'

                if wxsession.hasAddress
                  if content == 'Y' || content == 'y'
                    arr = wxsession.userinfo.split(' ')
                    console.log 'Yest:'+wxsession.userinfo
                    saveInfo arr[0], arr[2], arr[1]
                  else if content == 'N' || content == 'n'
                    wxsession.hasAddress = false
                    user.wx_status = JSON.stringify(wxsession)
                    user.save (err, result)->
                      if err
                        logger.error 'SavewxStatusE2:'+err
                        res.reply '抱歉，系统出错，请稍候再试'
                      else
                        res.reply '请输入您的收件人姓名、手机号码和收件地址，我们将会尽快为您派发奖品（以空格隔开，如：收件人 手机号码 收货地址）'
                  else
                    res.reply '输入错误，请输入 Y 或者 N'
                else
                  arr = content.split(' ')
                  mobile = arr[1]
                  if arr.length < 3 || mobile.length != 11
                    res.reply '格式不正确，请注意在收件人和手机号码后面添加空格及手机号码是否正确，请重新输入（以空格隔开，如：收件人 手机号码 收货地址）'
                  else
                    truename = arr[0]
                    mobile = arr[1]
                    address = content.replace truename+' '+mobile+' ', ''
                    saveInfo truename, address, mobile
              else
                res.reply {
                  type:'transfer_customer_service'
                  ToUserName:message.FromUserName
                  FromUserName:message.ToUserName
                  CreateTime:new Date().getTime()
                }
          else
            logger.error 'no user:'+wxmessage
            res.reply '系统出错，请稍候再试'
    )
  )

  onconfig: (config, next) ->
    mongo.config(config.get('mongo'))
    sms.config(config.get('sms'))
    Manager = require('../models/index').Manager
    Manager.findOne username: 'admin', (err, result)->
      if !result
        m = new Manager(
          username: 'admin'
          password: '666666'
        )
        m.save (err, result)->
          if err
            console.log err
          else
            console.log 'ManagerInited'

    next(null, config)