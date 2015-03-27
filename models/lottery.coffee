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
  enabled:type:Boolean,default:false
  description:String

Timestamps = require('mongoose-times')
LotterySchema.plugin Timestamps, created:"created_at", lastUpdated:"updated_at"

Mongoose.model 'Lottery', LotterySchema