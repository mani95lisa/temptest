'use strict'

models = require '../models'
Log = require('../models').Log
logger = require('log4js').getDefaultLogger()

module.exports =
  record : (req, action, value, callback)->
    ip = (req.headers['x-forwarded-for'] || '').split(',')[0] || req.connection.remoteAddress
    log = new Log(ip:ip,action:action,value:value)
    if(!callback)
      callback = (err, result)->
        if err
          logger.error 'LogError:'+err
        else
          logger.trace 'LogSaved:'+JSON.stringify(result)
    log.save callback