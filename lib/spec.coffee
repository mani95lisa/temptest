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
logger = require('log4js').getDefaultLogger()

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
      console.log 'UserInfoGot:'+JSON.stringify(result)
      callback null, result
    else
      api.getUser openid, (err, result)->
        console.log 'UserInfoInited:'+JSON.stringify(result)
        if !err
          user = new User(result)
          user.created_at = new Date()
          user.save callback
        else
          callback err

module.exports = (app)->

  config =
    token:'wechat'
    appid:appid
    encodingAESKey:'YN8K5TKe0aY2fBmYGKHPpDNxu4TRnD7hSyt8wVwb3dw'

  reply1 = (res)->
    s = '欢迎关注润石创投服务号，我们将竭诚为您服务！\n\n<a href="http://www.rsct.com">免费抽奖</a>\n客服电话：400-690-8862\n官方网址：<a href="http://www.rsct.com">www.rsct.com</a>'
    res.reply s

  app.use('/wechat', wechat(config, (req, res, next)->
      message = req.weixin

      logger.trace('WXM:'+JSON.stringify(message))

      if message.Event == 'subscribe'
        initUser message.FromUserName, (err, result)->
          reply1 res
      else
        reply1 res
    )
  )

  app.on 'middleware:after:session', (args)->
    passport.use(auth.localStrategy())
    app.use(passport.initialize())
    app.use(passport.session())
    app.use(auth.injectUser())
    passport.serializeUser(auth.serialize)
    passport.deserializeUser(auth.deserialize)

  onconfig: (config, next) ->
    mongo.config(config.get('mongo'))
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
            console.log result

    next(null, config)