'use strict'

models = require '../../../models'
SMS = models.SMS
utils = require('../../../lib/utils')
UpdateObject = utils.updateObject
auth = require '../../../lib/auth'
Log = require '../../../lib/log'
logger = require('log4js').getDefaultLogger()
sms = require '../../../lib/sms'
moment = require 'moment'
EventProxy = require 'eventproxy'
User = models.User

module.exports = (router)->

  router.get '/list', auth.isAuthenticated(), (req, res)->
    data = req.query

    ep = new EventProxy()
    ep.all 'count', 'result', (count, result)->
      res.json count:count, result:result, pageSize:data.pageSize

    if !data.pageSize
      data.pageSize = 10
    options = sort:created_at:-1
    if data.page
      options.skip = (data.page-1)*data.pageSize
      options.limit = data.pageSize
    query = {}
    query = mobile:data.mobile if data.mobile
    SMS.find query, null, options, ep.done 'result'
    SMS.count query, ep.done 'count'

  router.get '/left', auth.isAuthenticated(), (req, res)->
    sms.left (err, result)->
      if err
        res.json err:err
      else
        res.json result:result

  router.get '/code', (req, res)->
    data = req.query
    mobile = parseInt(data.mobile)
    if !mobile || data.mobile.length != 11
      res.json err:'手机号码格式错误'
    else
      date = moment().subtract(1, 'm').toDate()
      SMS.findOne mobile:mobile, created_at:$gt:date , (err, result)->
        if err
          logger.error 'Code:'+err
          res.json err:'获取验证码出错'
        else if result
          value = (result.created_at.getTime()-date.getTime())/1000
          res.json err:'请在 '+value+'秒 后再试'
        else
          code = utils.verifyCode()
          content = '您的验证码是 '+code
          ep = new EventProxy()
          ep.all 'sms', 'user', ->
            res.json result:true

          ep.fail (err)->
            logger.error 'CodeSave:'+err
            res.json err:'获取验证码出错，请再试一次'

          sms.send mobile, content, (err, result)->
            if err
              logger.error 'SMSSend:'+err
              res.json err:'发送验证码出错，请再试一次'
            else
              s = new SMS(
                mobile:mobile
                content:content
                created_at:new Date()
              )
              s.save ep.done('sms')
              User.findOne mobile:mobile, (err, result)->
                if err
                  res.json err:'获取验证码出错，请再试一次'
                else if result
                  logger.trace 'UpdateUserPWD:'+mobile
                  result.password = code
                  result.save ep.done 'user'
                else
                  logger.trace 'InitUser:'+mobile
                  user = new User(
                    mobile:mobile
                    password:code
                  )
                  user.save ep.done 'user'