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
OAuth = require 'wechat-oauth'

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

getUserToken = (openid, callback)->
  console.log 'GotoGetToken:'+openid
  User.findOne openid:openid, 'openid access_token refresh_token expires_in ac_created_at scope', (err, result)->
    if err
      logger.error 'GetUserTokenError:'+err
      callback err
    else if result
      console.log 'GetUserTokenResult:'+JSON.stringify(result)
#      result.create_at = result.token_created_at
      data = client.store[openid]
      console.log 'R2:'+JSON.stringify(data)
      data2 = {
        openid:result.openid
        access_token:result.access_token
        refresh_token:result.refresh_token
        expires_in:result.expires_in
        create_at:result.ac_created_at
        scope:result.scope
      }
      console.log 'R3:'+JSON.stringify(data2)
      callback null, data2
    else
      logger.error 'GetUserTokenError:No User'
      callback null, client.store[openid]

saveUserToken = (openid, token, callback)->
  console.log 'SaveUserToken:'+openid+'-'+JSON.stringify(token)
  User.findOne openid:openid, (err, result)->
    if err
      logger.error 'FindUserTokenError:'+err
      callback err
    else if result
      result.access_token = token.access_token
      result.ac_created_at = token.create_at
      result.refresh_token = token.refresh_token
      result.expires_in = token.expires_in
      result.scope = token.scope
      result.save (err, result)->
        if err
          logger.error 'SaveUserTokenError:'+err
          callback err
        else
          logger.trace 'SaveUserTokenOK:'+JSON.stringify(token)
          client.store[openid] = token
          callback null
    else
      logger.error 'SaveUserTokenError:No User By Openid'
      client.store[openid] = token
      callback null

client = new OAuth(appid, secret, getUserToken, saveUserToken)

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
          logger.warn 'NumberSaved:'+lottery_id+'-'+openid+'-'+num
          callback null, num

code_url = 'http://www.rsct.com/finance/weixin/sendverifycode.action'
regist_url = 'http://www.rsct.com/finance/weixin/register.action'
sign_in_url = 'http://www.rsct.com/finance/weixin/login.action'

module.exports = (router)->

  init = (req, res, result)->
    state = req.query.state
    params = getParams(state)
    logger.trace 'InitState:'+state
    user = ''
    ep = new EventProxy()
    ep.on 'ok', (user)->
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
                draw_url = '/draw_lottery'
                req.session.shareInfo = name:result.name,group_desc:result.group_desc,desc:result.description,img:result.thumb,url:share_url
                data =
                  uid:user._id
                  draw_url:draw_url
                  joined:result.joined
                  config:config
                  desc:result.description
                  group_desc:result.group_desc
                  url:share_url
                  img:result.thumb
                  countdown:countdown
                  name:result.name
                res.render 'lottery', data
        else
          res.json status:false

    User.findOne openid:result.openid, (err, userResult)->
      if err
        logger.error 'InitUserFindError:'+err
        res.json status:false
      else if userResult
        user = userResult
        if params.c
          user.channel = params.c
          arr = if user.channels then user.channels else []
          if arr.indexOf(params.c) == -1
            arr.push params.c
            user.channels = arr
        user.last_login = new Date()
        user.login_times++
        user.nickname = result.nickname
        user.sex = result.sex
        user.province = result.province
        user.city = result.city
        user.country = result.country
        user.headimgurl = result.headimgurl
        user.save (err, result)->
          logger.trace 'UserInitFindAndUpdated:'+JSON.stringify(result)
          ep.emit 'ok', result
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
            logger.error 'UserInitSaveError:'+err
            res.json err:err
          else
            logger.trace 'UserInitSaved:'+JSON.stringify(result)
            ep.emit 'ok', result

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
      res.json status:false
      return

    logger.trace 'Inited2:'+JSON.stringify(data)
    client.getUserByCode data.code, (err, result)->
      console.log 'GotAT:'+JSON.stringify(result)
      if err
        logger.error 'AutoInitError:'+err
        res.redirect 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init&response_type=code&scope=snsapi_userinfo&state='+data.state+'&connect_redirect=1#wechat_redirect'
      else
        init req, res, result

  router.get '/init', (req, res)->
    data = req.query
    if !data.code
      res.jsonp status:false
      return

    logger.trace 'Inited1:'+JSON.stringify(data)

    client.getUserByCode data.code, (err, result)->
      if err
        logger.error 'InitError:'+err
        res.json status:false
      else
        init req, res, result

  router.get '/', (req, res)->
    res.render 'login'

  router.get '/test2', (req, res)->
    Order.find {}, products:$elemMatch:name:req.query.name, (err, result)->
      res.json err:err, result:result

  router.get '/tp', (req, res)->
    res.render 'pages'

  router.get '/pages', (req, res)->
    chanel = if req.query.c then req.query.c else 'weixin'
    id = req.query.id
    if !id
      res.json status:false
    else
      getConfig req, (err, config)->
        Lottery.findById id, (err, result)->
          if err
            logger.error err
            res.json status:false
          else if result
            share_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init_auto&state=c___'+chanel+';;p___lottery;;id___'+id+'&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'
            data =
              config:config
              desc:result.description
              group_desc:result.group_desc
              url:share_url
              share_url:'http://rsct.swift.tf'+req.url
              img:result.thumb
              name:result.name
            res.render 'pages', data
          else
            res.json status:false

  router.get '/ttt', (req, res)->

  router.get '/success', (req, res)->
    res.render 'success', nums:[value:1111111,status:'true']

  router.get '/lottery', (req, res)->
    res.render 'lottery',draw_url:'/draw_lottery',joined:moment().format('YYMMDD'), countdown:94170370

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
                    logger.warn 'LotteryJoinedRecord:'+params.id+'-'+arr[0].value+'-'+user._id
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

  router.post '/do_sign_in', (req, res)->
    data = req.body
    user = req.session.user
    if req.session.doing
      return
    req.session.doing = true
    if !data.mobile
      res.json err:'请输入手机号'
    else if !data.password
      res.json err:'请输入密码'
    else
      formData = form:nickName:data.mobile,password:data.password
      logger.trace 'DoSignSignIn:'+JSON.stringify(formData)
      request.post sign_in_url, formData, (err, result, body)->
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
                else
                  logger.warn 'UserSetMobileOK:'+user._id+'-'+data.mobile
                  req.session.user = result
                res.json result:true
            else
              res.json result:true

  router.post '/do_sign_up', (req, res)->
    data = req.body
    user = req.session.user
    if data.nickname
      nickname = data.nickname
    else if user
      nickname = user.nickname
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
                else
                  logger.warn 'UserSetMobileOK:'+user._id+'-'+data.mobile
                  req.session.user = result
                res.json result:true
            else
              res.json result:true

  router.post '/test', (req, res)->
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
                  res.json err:'发送通知失败，请再试一次，有可能是用户尚未关注服务号所致'
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