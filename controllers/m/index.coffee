'use strict'

auth = require('../../lib/auth')
EventProxy = require 'eventproxy'
models = require('../../models/index')
Manager = models.Manager
User = models.User
Lottery = models.Lottery
LotteryRecord = models.LotteryRecord
moment = require 'moment'
logger = require('log4js').getDefaultLogger()
passport = require 'passport'
sms = require('../../lib/sms')

module.exports = (router)->

  router.post '/login', (req, res)->
    data = req.body

    passport.authenticate('local',
      successRedirect:req.session.goingTo || '/admin'
      failureRedirect:'/'
      failureFlash:true)(req, res, (value)->
        if value
          res.render 'login', err:value
        else
          res.redirect req.session.goingTo || '/admin'
    )

  router.get '/count',auth.isAuthenticated() , (req, res)->
    ep = new EventProxy()
    ep.all 'user', 'user1', 'user2', 'user3', 'lottery', 'record', 'got', 'dispatched', 'sms', (c1,nu,nru,user3, c2, c3,c4,c5, sms)->
      res.json user:c1,user1:nu,user2:nru,user3:user3,lottery:c2,record:c3,got:c4,dispatched:c5,sms:sms

#    ep.all 'author', 'collection', 'content','size', 'sms', (c1, c2, c3, c4, c5)->
#      console.log c4
#      size = 0
#      c4.forEach (v)->
#        size+=v.size
#      res.json author:c1,collection:c2,content:c3, size:size,sms:c5

    ep.fail (err)->
      logger.error err
      res.json err:JSON.stringify(err)

    now = moment(moment().format('YYYY-MM-DD')).toDate()
    User.count {}, ep.done 'user'
    User.count {created_at:$gte:now}, ep.done 'user1'
    User.count {
      created_at:$gte:now
      mobile:$exists:true
    }, ep.done 'user2'
    User.count {
      mobile:$exists:true
    }, ep.done 'user3'
    Lottery.count {}, ep.done 'lottery'
    LotteryRecord.count {}, ep.done 'record'
    LotteryRecord.count {status:true}, ep.done 'got'
    LotteryRecord.count {dispatched:true}, ep.done 'dispatched'
    sms.left ep.done 'sms'
#
#    SMS.left ep.done 'sms'
#    Author.count {}, ep.done 'author'
#    Collection.count {}, ep.done 'collection'
#    Content.count {}, ep.done 'content'
#    Collection.aggregate($group:_id:'0',size:$sum:'$size').exec ep.done 'size'