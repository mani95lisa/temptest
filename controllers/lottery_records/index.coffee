'use strict'

models = require('../../models')
LotteryRecord = models.LotteryRecord
UpdateObject = require('../../lib/utils').updateObject
auth = require('../../lib/auth')
EventProxy = require 'eventproxy'
moment = require 'moment'
logger = require('log4js').getDefaultLogger()
api = require('../index').api

module.exports = (router)->

  router.post '/update', auth.isAuthenticated(), (req, res)->
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
            if result.status && result.notify
              api.sendMessage '恭喜您于活动【'+lname+'】中奖\n\n'+result.notify+'\n\n（请在输入框输入【领奖】两字进入领奖流程）'
            logger.warn 'LRUpdated:'+diff
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
    if data.keywords
      switch parseInt(data.keywords).toString().length
        when 11
          query['user.mobile'] = data.keywords
        when 7
          query['number'] = data.keywords
        else
          query['lottery.name'] = new RegExp(data.keywords, 'i')

    filter = data.filter
    switch filter
      when '1'
        query['status'] = false
      when '2'
        query['status'] = true
      when '3'
        query['dispatched'] = true

    console.log('LRQuerry:'+JSON.stringify(query))

    LotteryRecord.find(query, null, options)
    .populate('lottery', 'name')
    .populate('user', 'mobile nickname')
    .exec ep.done 'result'
    LotteryRecord.count query, ep.done 'count'