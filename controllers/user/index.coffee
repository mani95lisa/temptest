'use strict'

User = require('../../models/index').User
auth = require('../../lib/auth')
UpdateObject = require('../../lib/utils').updateObject
EventProxy = require 'eventproxy'
models = require('../../models/index')
moment = require 'moment'
logger = require('log4js').getDefaultLogger()

module.exports = (router)->

  router.post '/update', auth.isAuthenticated(), (req, res)->
    data = req.body
    User.findById data._id, (err, result) ->
      if err
        logger.error 'UFind:'+err
        res.json err:err
      else
        diff = UpdateObject result, data, ['created_at']
        result.save (err, result) ->
          if err
            logger.error 'PUpdate:'+err
            res.json err:err
          else
            console.log diff
            res.json result:result

  router.post '/login', (req, res)->
    data = req.query
    User.getAuthenticated data.mobile, data.code, (err, result)->
      if err
        logger.error 'Login:'+data.mobile+'&'+err
        res.json err:err
      else
        res.json result:result

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
    query = mobile:new RegExp(data.keywords, 'i') if data.keywords
    User.find query, null, options, ep.done 'result'
    User.count query, ep.done 'count'