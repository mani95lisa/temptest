'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

TokenSchema = new Schema
  appid:String
  secret:String
  token:String
  get_ts:Date
  js_ticket:String
  js_ticket_expireTime:Date

Mongoose.model 'ProyaToken', TokenSchema