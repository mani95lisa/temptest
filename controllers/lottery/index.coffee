'use strict'

models = require('../../models')
Lottery = models.Lottery
LotteryRecord = models.LotteryRecord
UpdateObject = require('../../lib/utils').updateObject
auth = require('../../lib/auth')
EventProxy = require 'eventproxy'
Log = require '../../lib/log'
moment = require 'moment'
logger = require('log4js').getDefaultLogger()

module.exports = (router)->

  router.post '/add', auth.isAuthenticated(), (req, res)->
    data = req.body
    logger.trace JSON.stringify(data)
    lottery = new Lottery(data)
    lottery.save (err, result)->
      if err
        logger.error err
        res.json err:err
      else
        res.json result:result

  router.post '/update', auth.isAuthenticated(), (req, res)->
    data = req.body
    logger.trace JSON.stringify(data)
    Lottery.findById data._id, (err, result) ->
      if err
        logger.error 'PFind:'+err
        res.json err:err
      else
        diff = UpdateObject result, data, ['created_at']
        result.save (err, result) ->
          if err
            logger.error 'PUpdate:'+err
            res.json err:err
          else
            Log.record req, req.originalUrl, diff
            res.json result:result

  router.get '/list', auth.isAuthenticated(), (req, res)->
    data = req.query

    ep = new EventProxy()
    ep.all 'count', 'result', (count, result)->
      res.json count:count, result:result, pageSize:data.pageSize

    ep.fail (err)->
      logger.error err
      res.json err:err

    if !data.pageSize
      data.pageSize = 10
    options = sort:created_at:-1
    if data.page
      options.skip = (data.page-1)*data.pageSize
      options.limit = data.pageSize
    query = {}
    query = name:new RegExp(data.keywords, 'i') if data.keywords
    Lottery.find query, null, options, ep.done 'result'
    Lottery.count query, ep.done 'count'