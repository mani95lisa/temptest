'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

LotteryRecordSchema = new Schema
  lottery:type:Schema.Types.ObjectId,ref:'Lottery',index:true
  user:type:Schema.Types.ObjectId,ref:'User',index:true
  number:type:Number,required:true,index:true
  notify:String
  status:Boolean
  truename:String
  address:String
  mobile:Number
  dispatched:Boolean

Timestamps = require('mongoose-times')
LotteryRecordSchema.plugin Timestamps, created:"created_at", lastUpdated:"updated_at"

Mongoose.model 'LotteryRecord', LotteryRecordSchema