'use strict'

auth = require '../lib/auth'
API = require 'wechat-api'

appid = 'wx91e339282bcd9aa6'
secret = '7d5c869ddbacd15c9f9646a70b3951e9'
models = require '../models/index'
User = models.User
Token = models.Token
Dict = models.Dict
LotteryRecord = models.LotteryRecord
EventProxy = require 'eventproxy'
logger = require('log4js').getDefaultLogger()
request = require 'request'
moment = require 'moment'
utils = require '../lib/utils'
UpdateObject = utils.updateObject
SMS = require '../lib/sms'
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
      logger.warn 'GetUserTokenError:No User'
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
          callback null
    else
      logger.warn 'SaveUserTokenError:No User By Openid'
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

host = 'http://uv.proya.com'
home_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init_auto&scope=snsapi_base&connect_redirect=1#wechat_redirect'
console.log 'HomeURL:'+home_url

getUrl = (channel, page)->
  return 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init_auto&state=c___'+channel+';;p___'+page+'&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'

getConfig = (req, callback)->
  url = host + req.url
  api.getJsConfig debug: true, jsApiList: ['onMenuShareTimeline', 'onMenuShareAppMessage', 'onMenuShareQQ',
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

errorHandler = (res, errorString, redirect_url)->
  es = if errorString then errorString else '抱歉，系统出错，请稍候再试'
  res.render 'error', error:es, url:redirect_url

LINK_ERROR = '抱歉，链接错误，请重新再试'
SYSTEM_ERROR = '抱歉，系统出错，请稍候再试'
WEIXIN_AUTH_ERROR = '抱歉，微信授权错误，请重新再试'
TIME_OUT_ERROR = '抱歉，页面打开时间过长或连接丢失，请重新再试'

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
        data =
          config:config
          share_url:home_url
        res.render 'proya', data
#        req.session.state = state
#        page = params.p
#        if page == 'lottery'
#          id = params.id
#          if !id
#            errorHandler res, LINK_ERROR
#          else
#            Lottery.findById id, (err, result)->
#              if err
#                logger.error err
#              else if result
#                plus = 0
#                if result.plus
#                  plus = result.plus
#                result.joined += plus
#                share_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init_auto&state=c___'+params.c+';;p___'+params.p+';;id___'+id+'&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'
#                countdown = moment(result.end).valueOf() - moment().valueOf()
#                begin = moment().valueOf() - moment(result.begin).valueOf()
#                draw_url = '/draw_lottery'
#                success_bg_url = if result.success_bg_url then result.success_bg_url else 'imgs/success_bg.jpg'
#                req.session.shareInfo =
#                  success_bg_url:success_bg_url
#                  begin:result.begin
#                  end:result.end
#                  name:result.name
#                  group_desc:result.group_desc
#                  desc:result.description
#                  img:result.thumb
#                  url:share_url
#                detail_url = if result.detail_url then result.detail_url else 'imgs/need_know_detail.jpg'
#                bg_url = if result.bg_url then result.bg_url else 'imgs/lottery_bg.jpg'

#                res.render 'lottery', data
#        else
#          errorHandler res, LINK_ERROR

    User.findOne openid:result.openid, (err, userResult)->
      if err
        logger.error 'InitUserFindError:'+err
        errorHandler res, SYSTEM_ERROR
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
            errorHandler res, SYSTEM_ERROR
          else
            logger.trace 'UserInitSaved:'+JSON.stringify(result)
            ep.emit 'ok', result

  router.get '/init_auto', (req, res)->
    headers = req.headers
    data = req.query
    if !data.code
      logger.error 'InitAuto微信授权错误'
      errorHandler res, WEIXIN_AUTH_ERROR
      return

    logger.trace 'Inited2:'+JSON.stringify(data)
    client.getUserByCode data.code, (err, result)->
      if err
        logger.warn 'AutoInitError:'+err
        res.redirect 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init&response_type=code&scope=snsapi_userinfo&state='+data.state+'&connect_redirect=1#wechat_redirect'
      else
        init req, res, result

  router.get '/init', (req, res)->
    data = req.query
    if !data.code
      logger.error 'Init微信授权错误'
      errorHandler res, WEIXIN_AUTH_ERROR
      return

    logger.trace 'Inited1:'+JSON.stringify(data)

    client.getUserByCode data.code, (err, result)->
      if err
        logger.error 'InitError:'+err
        errorHandler res, WEIXIN_AUTH_ERROR
      else
        init req, res, result

  router.get '/', (req, res)->
    res.redirectTo '/w'

  router.get '/test2', (req, res)->
    Order.find {}, products:$elemMatch:name:req.query.name, (err, result)->
      res.json err:err, result:result

  router.get '/tp', (req, res)->
    res.render 'pages'

  router.get '/pages', (req, res)->
    chanel = if req.query.c then req.query.c else 'weixin'
    id = req.query.id
    if !id
      errorHandler res, LINK_ERROR
    else
      getConfig req, (err, config)->
        Lottery.findById id, (err, result)->
          if err
            logger.error err
            errorHandler res, SYSTEM_ERROR
          else if result
            share_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri='+host+'/init_auto&state=c___'+chanel+';;p___lottery;;id___'+id+'&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'
            data =
              config:config
              desc:result.description
              group_desc:result.group_desc
              url:share_url
              share_url:'http://lottery.rsct.com'+req.url
              img:result.thumb
              name:result.name
            res.render 'pages', data
          else
            errorHandler res, LINK_ERROR

  router.get '/ttt', (req, res)->

  router.get '/success', (req, res)->
    res.render 'success', nums:[value:1111111,status:'true']

  router.get '/lottery', (req, res)->
    detail_url = 'imgs/need_know_detail_3.jpg'
    bg_url = 'imgs/lottery_bg.jpg'
    res.render 'lottery',bg_url:bg_url,detail_url:detail_url,draw_url:'/draw_lottery',joined:moment().format('YYMMDD'), countdown:94170370

  limit = {
    9:[10,10,10,10]
    12:[15,1,1,1]
    13:[15,1,1,1]
    14:[7,0,0,0]
    15:[7,0,0,0]
    16:[1,0,0,0]
    17:[1,0,0,0]
    18:[4,0,0,0]
    19:[15,1,0,1]
    20:[15,0,0,1]
    21:[7,0,0,0]
    22:[7,0,0,0]
    23:[1,0,0,0]
    24:[1,0,0,0]
    25:[2,0,0,0]
    26:[1,0,0,0]
    27:[1,0,0,0]
  }
#  ratio = [0.1,0.05,0.04,0.01]
  ratio = [0.8,0.7,0.6,0.5]

  router.post '/record_lottery', (req, res)->
    session = req.session
    data = req.body
    if !session.lid || !data.lid
      res.json err:'网络连接超时啦，请稍候再试或截图保留中奖证据并联系客服'
      return
    LotteryRecord.findById data.lid, (err, result)->
      if err
        res.json err:'网络连接超时啦，请稍候再试或截图保留中奖证据并联系客服'
      else
        result.truename = data.truename
        result.mobile = data.mobile
        result.email = data.email
        result.save (err, result)->
          if err
            res.json err:'网络连接超时啦，请稍候再试或截图保留中奖证据并联系客服'
          else
            res.json result:true

  router.get '/draw_lottery', (req, res)->
    session = req.session
    user = session.user
    if !user
      console.log 'no user:'
      errorHandler res, TIME_OUT_ERROR
    else
      today = moment().format('YYYY-MM-DD')
      rm = Math.random()
      limitObject = limit[new Date().getDate()]
      gotid = ''
      ratio.forEach (r)->
        lindex = ratio.indexOf(r)
        if r > rm
          gotid = lindex
      if gotid != ''
        LotteryRecord.count day:today,lottery:gotid, (err, result)->
          if err
            res.json result:false
          else
            if limitObject && limitObject[gotid] >= result
              console.log 'limited'
              res.json result:false
            else
              lr = new LotteryRecord(
                openid:user.openid
                user:user._id
                day:today
                lottery:gotid
              )
              console.log 'got:',gotid
              lr.save (err, result)->
                if err
                  res.json result:false
                else
                  session.lid = result._id
                  session.lottery = result:gotid
                  res.json result:lid:result._id,lot:gotid
      else
        res.json result:false

  router.post '/like', (req, res)->
    session = req.session
    data = req.body
    if !session.user
      res.json result:false
      return

    Dict.findOneAndUpdate
      key: "likes"
      data
      upsert: true
      (err, result) ->
        if err
          res.json err:err
        else
          res.json result: true

  router.get '/likes', (req, res)->
    session = req.session
    data = req.query
    if !session.user || !data.id
      res.json result:false
      return

    Dict.findOne key:'likes', (err, result)->
      if err
        res.json result:false
      else
        res.json result:result.value

  router.post '/record_lottery', (req, res)->
    session = req.session
    id = session.id
    if !session.user || !id
      res.render 'error', error:'您太长时间没操作了，请重新再试'
      return

    data = req.body
    err = ''
    if !data.mobile || (data.mobile && data.mobile.length != 11)
      err = '手机号码格式不对'
    else if !data.truename
      err = '收件人不能为空'
    else if !data.address
      err = '收货地址不能为空'
    if err
      res.render 'error', error:err
      return
    else
      LotteryRecord.findById id, (err, result)->
        if err
          res.render 'error', error:'系统出问题了，请稍后再试'
        else
          result.truename = data.truename
          result.mobile = data.mobile
          result.address = data.address
          result.save (err, result)->
            if err
              res.render 'error', error:'系统出问题了，请稍后再试'
            else
              res.json status:true


  router.get '/get_lottery', (req, res)->
    session = req.session
    if !session.user
      res.json status:false
      return

    ep = new EventProxy()
    ep.all 'limit', 'ratio', 'count', (limit, ratio, count)->
      limit = limit.value
      ratio = ratio.value
      if count >= limit
        res.json status:false,reason:'f'
      else
        value = Math.random()
        if value > ratio
          lr = new LotteryRecord(
            day:moment().format('YYYY-MM-DD')
          )
          lr.save (err, result)->
            if err
              res.json status:false, err:err
            else
              session.id = result._id
              res.json status:true
        else
          res.json status:false, reason:'n'

    ep.fail (err)->
      res.json status:false, err:err

    Dict.findOne key:'LotteryLimit', ep.done 'limit'
    Dict.findOne key:'LotteryRatio', ep.done 'ratio'
    LotteryRecord.count day:moment().format('YYYY-MM-DD'), ep.done 'count'

  router.get '/lucky', (req, res)->
    Dict.findOne key:'CurrentActivity','value',(err, result) ->
      if result && result.value
        res.redirect result.value
      else
        errorHandler res

  router.get '/baecheck', (req, res)->
    res.json status:true

  router.get '/proya', (req, res)->
    req.session.user = {}
    getConfig req, (result)->
      res.render 'proya', config:result,share_url:'http://uv.proya.com/proya'

  router.get '/admin', auth.isAuthenticated(), (req, res)->
    nav = [
      {path:'dashboard',name:'仪表盘',icon:'fa fa-dashboard'}
      {path:'joined',name:'得奖管理',icon:'fa fa-gift'}
      {path:'user',name:'用户管理',icon:'fa fa-users'}
    ]
    res.render 'admin', nav:nav