'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

LotteryRecordSchema = new Schema
  openid:type:String,index:true
  user:type:Schema.Types.ObjectId,ref:'ProyaUser',index:true
  day:type:String,index:true
  truename:String
  address:String
  mobile:Number
  lottery:String

Timestamps = require('mongoose-times')
LotteryRecordSchema.plugin Timestamps, created:"created_at", lastUpdated:"updated_at"

Mongoose.model 'ProyaLotteryRecord', LotteryRecordSchema