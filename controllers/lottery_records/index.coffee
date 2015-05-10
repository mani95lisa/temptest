'use strict'

models = require('../../models')
LotteryRecord = models.LotteryRecord
User = models.User
Lottery = models.Lottery
UpdateObject = require('../../lib/utils').updateObject
auth = require('../../lib/auth')
EventProxy = require 'eventproxy'
moment = require 'moment'
logger = require('log4js').getDefaultLogger()

module.exports = (router)->

  router.get '/list', auth.isAuthenticated(), (req, res)->
    data = req.query

    ca = JSON.parse(data.category) if data.category

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

    ep2 = new EventProxy()
    ep2.on 'ok', ->
      console.log('LRQuerry:'+JSON.stringify(query))

      LotteryRecord.find(query, null, options)
      .exec ep.done 'result'
      LotteryRecord.count query, ep.done 'count'

    ep2.emit 'ok'
