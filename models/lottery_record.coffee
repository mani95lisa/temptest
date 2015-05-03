'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

LotteryRecordSchema = new Schema
  openid:type:String,index:true
  user:type:Schema.Types.ObjectId,ref:'User',index:true
  number:type:Number,required:true,index:true
  notify:String
  status:type:Boolean,default:false
  truename:String
  address:String
  mobile:Number
  dispatched:type:Boolean,default:false

Timestamps = require('mongoose-times')
LotteryRecordSchema.plugin Timestamps, created:"created_at", lastUpdated:"updated_at"

Mongoose.model 'ProyaLotteryRecord', LotteryRecordSchema