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
      .populate('lottery', 'name')
      .populate('user', 'mobile nickname')
      .sort(number:1)
      .exec ep.done 'result'
      LotteryRecord.count query, ep.done 'count'

    filter = data.filter
    switch filter
      when '1'
        query['status'] = false
      when '2'
        query['status'] = true
      when '3'
        query['dispatched'] = true

    if data.keywords
      switch parseInt(data.keywords).toString().length
        when 11
          User.findOne mobile:data.keywords, '_id', (err, result)->
            if err
              res.json err:err
              logger.error 'FindU:'+err
            else
              query['user'] = result._id if result
              ep2.emit 'ok'
        when 7
          query['number'] = $gte:data.keywords
          ep2.emit 'ok'
        else
          Lottery.findOne name:new RegExp(data.keywords, 'i'), '_id', (err, result)->
            if err
              res.json err:err
              logger.error 'FindL:'+err
            else
              query['lottery'] = result._id if result
              ep2.emit 'ok'
    else
      ep2.emit 'ok'
