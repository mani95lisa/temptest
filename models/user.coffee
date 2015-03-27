'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

UserSchema = new Schema
  openid:type:String,index:unique:true
  nickname:String
  truename:String
  mobile:String
  birthday:Date
  address:String
  addresses:[]
  sex:String
  province:String
  city:String
  country:String
  subscribe_time:String
  remark:String
  headimgurl:String
  mobile:type:String,index:true
  verify_code:String #手机验证码
  score:Number #积分
  order_times:type:Number,default:0
  login_times:type:Number,default:0
  last_login:Date
  created_at:Date

Mongoose.model 'User', UserSchema