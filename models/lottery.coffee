'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

LotterySchema = new Schema
  name:type:String, required:true, index:unique:true
  value:String
  thumb:String
  begin:Date
  end:Date
  joined:type:Number,default:0
  link_url:String
  detail_url:String
  plus:Number
  enabled:type:Boolean,default:false
  group_desc:String
  description:String

Timestamps = require('mongoose-times')
LotterySchema.plugin Timestamps, created:"created_at", lastUpdated:"updated_at"

Mongoose.model 'Lottery', LotterySchema