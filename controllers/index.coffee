'use strict'

auth = require '../lib/auth'
API = require 'wechat-api'

appid = 'wx1f9fe13fd3655a8d'
secret = '2a3792094fc7e3b91a4920a8afb0a0c1'
models = require '../models/index'
User = models.User
Token = models.Token
Dict = models.Dict
Lottery = models.Lottery
LotteryRecord = models.LotteryRecord
EventProxy = require 'eventproxy'
logger = require('log4js').getDefaultLogger()
request = require 'request'
moment = require 'moment'
utils = require '../lib/utils'
UpdateObject = utils.updateObject

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

get_js_sdk_ticket = (type, cb)->
  console.log 'get js ticket', type
  Token.findOne appid:appid, (err,result)->
    if err
      logger.error 'GetJSTicketError:'+err
      cb null, null
    else if result && result.js_ticket
      cb null, ticket: result.js_ticket, expireTime:result.js_ticket_expireTime
    else
      cb null, null

save_js_sdk_ticket = (type, ticket, cb)->
  console.log 'save js ticket', type, ticket
  Token.findOne appid:appid, (err,result)->
    if err
      logger.error 'SaveJSTicketError:'+err
      cb null, null
    else if result
      result.js_ticket = ticket.ticket
      result.js_ticket_expireTime = ticket.expireTime
      result.save cb
    else
      token = new Token(
        appid:appid
        secret:secret
        js_ticket:ticket.ticket
        js_ticket_expireTime:ticket.expireTime
      )
      token.save cb

api.registerTicketHandle get_js_sdk_ticket, save_js_sdk_ticket

host = 'http://rsct.swift.tf'
home_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init_auto&state=c___weixin;;p___lottery&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'

getUrl = (channel, page)->
  return 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init_auto&state=c___'+channel+';;p___'+page+'&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'

menu =
  'button':[
    {
      name:'我的账户'
      type:'view'
      url:'http://www.rsct.com/finance/website/to_login.action'
    }
    {
      name:'帮你赚钱'
      type:'view'
      url:'http://www.rsct.com/finance/website/index.action'
    }
    {
      name:'关于润石'
      type:'view'
      url:'http://www.rsct.com/finance/website/dima.action'
    }
  ]

getConfig = (req, callback)->
  url = host + req.url
  api.getJsConfig debug: false, jsApiList: ['onMenuShareTimeline', 'onMenuShareAppMessage', 'onMenuShareQQ',
                                            'onMenuShareWeibo'], url: url, (err, result)->
    callback err, result

inTime = (times)->
  now = moment().valueOf()
  if !times || !times.length
    return false
  else
    result = false
    times.forEach (t)->
      s = moment(t.start, 'HH:mm').valueOf()
      e = moment(t.end, 'HH:mm').valueOf()
      if s <= now && e >= now
        result = true
    return result

getParams = (state)->
  params = {}
  arr = state.split(';;')
  arr.forEach (item)->
    temp = item.split('___')
    if temp.length == 2
      params[temp[0]] = temp[1]
  return params

getRewardNumber = (lottery_id, user,openid, callback)->
  num = utils.getRandomInt(1000000,9999999)
  LotteryRecord.findOne lottery:lottery_id,number:num, (err, result)->
    if err
      logger.error err
      callback err
    else if result
      getRewardNumber lottery_id, user, callback
    else
      lr = new LotteryRecord(
        lottery:lottery_id
        user:user
        number:num
        openid:openid
      )
      lr.save (err, result)->
        if err
          logger.error err
          callback err
        else
          callback null, num

code_url = 'http://182.92.237.234:8080/finance/weixin/sendverifycode.action'
regist_url = 'http://182.92.237.234:8080/finance/weixin/register.action'

module.exports = (router)->

  init = (req, res, result)->
    state = req.query.state
    params = getParams(state)
    console.log 'State:'+state+'Page:'+params.p
    User.findOne openid:result.openid, (err, userResult)->
      if err
        logger.error 'UserFindError:'+err
        res.json err:err
      else
        ep = new EventProxy()
        ep.on 'ok', ->
          getConfig req, (err, config)->
            if(err)
              logger.error 'ConfigError:'+err
            req.session.user = user
            req.session.state = state
            page = params.p
            if page == 'lottery'
              id = params.id
              if !id
                res.json status:false
              else
                Lottery.findById id, (err, result)->
                  if err
                    logger.error err
                  else if result
                    s = moment().format('YYMMDD')
                    result.joined += parseInt(s)
                    share_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init_auto&state=c___'+params.c+';;p___'+params.p+';;id___'+id+'&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'
                    countdown = moment(result.end).valueOf() - moment().valueOf()
                    console.log 'CD:'+countdown
                    draw_url = '/draw_lottery'
                    req.session.shareInfo = name:result.name,desc:result.description,img:result.thumb,url:share_url
                    data =
                      uid:user._id
                      draw_url:draw_url
                      joined:result.joined
                      config:config
                      desc:result.description
                      url:share_url
                      img:result.thumb
                      countdown:countdown
                      name:result.name
                    res.render 'lottery',data
            else
              res.json status:false

        user = ''
        if userResult
          user = userResult
          user.last_login = new Date()
          user.login_times++
          user.save (err, result)->
            ep.emit 'ok'
        else
          user = new User(
            openid:result.openid
            last_login:new Date()
            created_at:new Date()
          )
          user.nickname = result.nickname
          user.sex = result.sex
          user.province = result.province
          user.city = result.city
          user.country = result.country
          user.headimgurl = result.headimgurl
          user.save (err, result)->
            if err
              logger.error 'UserSaveError:'+err
              res.json err:err
            else
              logger.trace 'UserSaved:'+JSON.stringify(result)
              ep.emit 'ok'

  router.get '/menu', (req, res)->
    api.createMenu menu, (err, result)->
      if err
        logger.error err
      else
        logger.trace 'menu setted:',result
        api.getMenu (err, result)->
          res.json result

  router.get '/init_auto', (req, res)->
    headers = req.headers
    data = req.query
    if !data.code
      res.jsonp status:false
      return

    console.log 'Inited2:'+JSON.stringify(data)

    request.get 'https://api.weixin.qq.com/sns/oauth2/access_token?appid='+appid+'&secret='+secret+'&code='+data.code+'&grant_type=authorization_code', (err, result)->
      if err
        logger.error 'UserCodeError2:'+err
        res.json status:false
      else
        result = JSON.parse result.body
        console.log 'Inited2Result:'+JSON.stringify(result)
        if result.errcode
          logger.error 'UserCodeError2:'+result.errmsg
          res.json status:false
        else
          access_token = result.access_token
          refresh_token = result.refresh_token
          openid = result.openid

          if !access_token
            logger.error 'UserAccessToeknError:'+JSON.stringify(result)
            res.json status:false
          else
            request.get 'https://api.weixin.qq.com/sns/userinfo?access_token='+access_token+'&openid='+openid+'&lang=zh_CN', (err, result)->

              reinit = ->
                res.redirect 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init&response_type=code&scope=snsapi_userinfo&state='+data.state+'&connect_redirect=1#wechat_redirect'

              if err
                logger.error 'UserCodeError3:'+err
                reinit()
              else
                result = JSON.parse result.body
                if result.errcode
                  logger.error 'UserInfoError:'+result.errmsg
                  reinit()
                else
                  logger.trace 'Init:'+JSON.stringify result
                  init req, res, result

  router.get '/init', (req, res)->
    data = req.query
    if !data.code
      res.jsonp status:false
      return

    request.get 'https://api.weixin.qq.com/sns/oauth2/access_token?appid='+appid+'&secret='+secret+'&code='+data.code+'&grant_type=authorization_code', (err, result)->
      if err
        logger.error 'UserCodeError1:'+err
        res.jsonp status:false
      else
        result = JSON.parse result.body
        if result.errcode
          logger.error 'UserCodeError2:'+result.errmsg
          res.jsonp status:false
        else
          access_token = result.access_token
          refresh_token = result.refresh_token
          openid = result.openid

          if !access_token
            logger.error 'UserAccessToeknError:'+JSON.stringify(result)
            res.jsonp status:false
          else
            request.get 'https://api.weixin.qq.com/sns/userinfo?access_token='+access_token+'&openid='+openid+'&lang=zh_CN', (err, result)->
              if err
                logger.error 'UserCodeError3:'+err
                res.jsonp status:false
              else
                result = JSON.parse result.body
                if result.errcode
                  logger.error 'UserInfoError:'+result.errmsg
                  res.jsonp status:false
                else
                  init req, res, result

  router.get '/', (req, res)->
    res.render 'login'

  router.get '/test2', (req, res)->
    Order.find {}, products:$elemMatch:name:req.query.name, (err, result)->
      res.json err:err, result:result

  router.get '/pages', (req, res)->
    res.render 'pages', url:home_url

  router.get '/success', (req, res)->
    res.render 'success'

  router.get '/lottery', (req, res)->
    res.render 'lottery',joined:moment().format('YYMMDD'), countdown:94170370

  router.get '/draw_lottery', (req, res)->
    session = req.session
    user = session.user
    state = session.state
    shareInfo = req.session.shareInfo
    if !user || !state
      res.json status:false
    else if user.mobile
      params = getParams(state)
      getConfig req, (err, config)->
        shareInfo.config = config
        LotteryRecord.find lottery:params.id,user:user._id, (err, result)->
          if result && result.length
            arr = []
            result.forEach (r)->
              status = if r.status then '已中奖' else '未开奖'
              arr.push value:r.number,status:status
            shareInfo.nums = arr
            shareInfo.uid = user._id
            res.render 'success', shareInfo
          else
            getRewardNumber params.id, user._id, user.openid, (err, result)->
              if err
                res.josn status:false
              else
                arr = [value:result,status:'未开奖']
                shareInfo.nums = arr
                shareInfo.uid = user._id
                Lottery.findByIdAndUpdate params.id, $inc:joined:1, (err, result)->
                  if err
                    logger.error 'RecordLotterJoinErr:'+err
                  else
                    logger.trace 'LotteryJoinedRecord:'+params.id+'-'+arr[0].value+'-'+user._id
                res.render 'success', shareInfo
    else
      res.render 'sign_up'

  router.get '/shared_lottery', (req, res)->
    session = req.session
    user = session.user
    state = session.state
    shareInfo = req.session.shareInfo
    if !user || !state
      res.json status:false
    else if !user.registered
      params = getParams(state)
      getConfig req, (err, config)->
        shareInfo.config = config
        LotteryRecord.find lottery:params.id,user:user._id, (err, result)->
          if result.length == 3
            arr = []
            result.forEach (r)->
              status = if r.status then '已中奖' else '未开奖'
              arr.push value:r.number,status:status
            shareInfo.nums = arr
            shareInfo.uid = user._id
            res.render 'success', shareInfo
          else if result.length == 1
            ep = new EventProxy()
            ep.all 'n1', 'n2', (n1, n2)->
              arr = [value:result[0].number,status:'未开奖']
              arr.push value:n1, status:'未开奖'
              arr.push value:n2, status:'未开奖'
              shareInfo.nums = arr
              shareInfo.uid = user._id
              res.render 'success', shareInfo

            ep.fail (err)->
              logger.error err
              res.json status:false

            getRewardNumber params.id, user._id, user.openid, ep.done 'n1'
            getRewardNumber params.id, user._id, user.openid, ep.done 'n2'

  router.post '/verify_code', (req, res)->
    mobile = req.body.mobile
    if !mobile
      res.json err:'手机号不能为空'
    else
      request.post code_url, form:mobileNo:mobile, (err, result, body)->
        if err
          res.json err:err
        else
          body = JSON.parse(body)
          if body.result == '1'
            res.json err:body.tip
          else
            res.json result:true


  router.get '/sign_up', (req, res)->
    res.render 'sign_up'

  router.post '/code', (req, res)->
    console.log req.body

  router.post '/do_sign_up', (req, res)->
    data = req.body
    user = req.session.user
    nickname = if user then user.nickname else 'test'
    if req.session.doing
      console.log 'doing'
      return
    req.session.doing = true
    if !data.mobile
      res.json err:'请输入手机号'
    else if !data.code
      res.json err:'请输入验证码'
    else if !data.password
      res.json err:'请输入密码'
    else
      formData = form:mobileNo:data.mobile,nickName:nickname,password:data.password,rePassword:data.password,verifyCode:data.code
      logger.trace 'DoSignUp:'+JSON.stringify(formData)
      request.post regist_url, formData, (err, result, body)->
        req.session.doing = false
        if err
          res.json err:err
        else
          body = JSON.parse(body)
          logger.trace 'Registered:'+JSON.stringify(body)
          if body.result == '1'
            res.json err:body.tip
          else
            if user
              User.findByIdAndUpdate user._id, $set:mobile:data.mobile, (err, result)->
                if err
                  logger.error 'UserSetMobileError:'+user._id+'-'+data.mobile+'-'+err
                res.redirect '/draw_lottery'
            else
              res.redirect '/draw_lottery'

  router.post '/lottery_records/update', auth.isAuthenticated(), (req, res)->
    data = req.body
    logger.trace 'LotteryRecordUpdate:'+JSON.stringify(data)
    LotteryRecord.findById(data._id)
    .populate('user', 'openid')
    .populate('lottery', 'name')
    .exec (err, result) ->
      if err
        logger.error 'LRind:'+err
        res.json err:err
      else
        diff = UpdateObject result, data, ['created_at','lottery','user','updated_at']
        lname = result.lottery.name
        result.save (err, result) ->
          if err
            logger.error 'LRUpdated:'+err
            res.json err:err
          else
            logger.warn 'LRUpdated:'+diff
            if result.status && result.notify
              api.sendText result.user.openid, '恭喜您于活动【'+lname+'】中奖\n\n'+result.notify+'\n\n（请在输入框输入【领奖】两字进入领奖流程）', (err, result)->
                if err
                  logger.error 'notify error:'+err
                  res.err '发送通知失败，请再试一次'
                else
                  res.json result:result
            else
              res.json result:result

  router.get '/admin', auth.isAuthenticated(), (req, res)->
    nav = [
      {path:'dashboard',name:'仪表盘',icon:'fa fa-dashboard'}
      {path:'lottery',name:'抽奖管理',icon:'fa fa-list'}
      {path:'joined',name:'得奖管理',icon:'fa fa-gift'}
      {path:'user',name:'用户管理',icon:'fa fa-users'}
      {path:'setting', name:'系统设置', icon:'fa fa-cogs'}
    ]
    res.render 'admin', nav:nav