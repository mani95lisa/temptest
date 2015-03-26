'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

request = require 'request'

LogSchema = new Schema
  ip:String
  ip_address:String
  action:String
  value:String
  manager:type:Schema.Types.ObjectId,ref:'Manager'
  created_at:Date

LogSchema.pre 'save', (next)->
  log = this
  log.created_at = new Date()
  if log.ip
    request.get 'http://api.map.baidu.com/location/ip?ak=AfKh7pndgGSZPwwdOXTIPB94&ip='+log.ip, (err, res, body)->
      if !err
        log.ip_address = JSON.parse(body).address
      next()
  else
    next()

Mongoose.model 'Log', LogSchema