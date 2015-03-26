'use strict'

auth = require '../lib/auth'
API = require 'wechat-api'

appid = 'wx1f9fe13fd3655a8d'
secret = '2a3792094fc7e3b91a4920a8afb0a0c1'
models = require '../models/index'
User = models.User
Token = models.Token
Dict = models.Dict
EventProxy = require 'eventproxy'
logger = require('log4js').getDefaultLogger()
request = require 'request'
moment = require 'moment'

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

home_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx147e9f502d858faa&redirect_uri=http://lovecoffee.duapp.com/init_auto&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'

menu =
  'button':[
    {
      name:'点餐'
      type:'view'
      url:home_url
    }
  ]

host = 'http://lovecoffee.duapp.com'

getConfig = (req, callback)->
  url = host + req.url
  console.log('url:' + url)
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

module.exports = (router)->

  init = (req, res, result)->
    state = req.query.state
    console.log 'State:'+state
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
            req.session.user = user._id
            ep = new EventProxy()
            ep.all 'products', 'pmTimes', 'pmProducts', (products, pmTimes, pmProducts)->
              categories = []
              cas = []
              dic = {}
              list = []
              newPrices = {}
              times = pmTimes.list if pmTimes
              pmProducts = pmProducts.list if pmProducts
              pmEnabled = inTime(times)
              if !user.order_times
                pmEnabled = false
              products.forEach (p)->
                if !dic[p.category]
                  dic[p.category] = []
                arr = dic[p.category]

                if pmEnabled && pmProducts && pmProducts.length
                  pmProducts.every (pm)->
                    if p.name == pm.name
                      p.prices = pm.prices
                      p.discount = true
                      return false
                    else
                      return true

                p.prices.reverse()
                newPrices[p.id] = p.prices
                arr.push p
                index = categories.indexOf(p.category)
                if index == -1
                  categories.push p.category
                  ca = name:p.category,index:categories.indexOf(p.category)
                  cas.push ca
                  list.push category:ca,products:dic[p.category]
              last_ordered = userResult.last_ordered
              ordered = []
              dic = {}
              last_ordered.forEach (o)->
                arr = newPrices[o.id]
                arr.every (p)->
                  if p.label == o.price_label
                    o.price = p.value

                if !dic[o.id]
                  dic[o.id] = id:o.id,name:o.name,detail:[type:o.price_label,count:o.sum,price:o.price]
                  ordered.push dic[o.id]
                else
                  dic[o.id].detail.push type:o.price_label,count:o.sum,price:o.price

              res.render 'index', ordered:JSON.stringify(ordered),config:config,url: home_url, list:list, categories:cas, userinfo:JSON.stringify(user)

            Dict.findOne key:'PMTimes', ep.done('pmTimes')
            Dict.findOne key:'PMProducts', ep.done('pmProducts')

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
                res.redirect 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+appid+'&redirect_uri=http://lovecoffee.duapp.com/init&response_type=code&scope=snsapi_userinfo&state='+data.state+'&connect_redirect=1#wechat_redirect'

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
        console.log 'UCErr1'+err
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
                console.log 'UCErr2'+err
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
    res.render 'pages'

  router.get '/lottery', (req, res)->
    res.render 'lottery',joined:0

  router.get '/draw_lottery', (req, res)->
    res.render 'success', nums:[value:1234567,status:'未开奖']

  router.get '/sign_up', (req, res)->
    res.render 'sign_up'

  router.post '/do_sign_up', (req, res)->
    res.redirect '/draw_lottery'

  router.get '/admin', auth.isAuthenticated(), (req, res)->
    nav = [
      {path:'dashboard',name:'仪表盘',icon:'fa fa-dashboard'}
      {path:'lottery',name:'抽奖管理',icon:'fa fa-list'}
      {path:'joined',name:'得奖管理',icon:'fa fa-gift'}
      {path:'user',name:'用户管理',icon:'fa fa-users'}
      {path:'setting', name:'系统设置', icon:'fa fa-cogs'}
    ]
    res.render 'admin', nav:nav