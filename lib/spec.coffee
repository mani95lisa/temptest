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