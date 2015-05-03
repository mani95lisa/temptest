'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

UserSchema = new Schema
  openid:type:String,index:unique:true
  nickname:String
  truename:String
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
  mobile:type:String,index:sparse:true
  mobile2:String #送货手机号
  verify_code:String #手机验证码
  score:Number #积分
  order_times:type:Number,default:0
  login_times:type:Number,default:0
  registered:type:Boolean,default:false
  channel:String
  channels:[String]
  access_token:String
  refresh_token:String
  expires_in:Number
  scope:String
  ac_created_at:Number
  wx_status:String
  last_login:Date
  created_at:Date

Mongoose.model 'ProyaUser', UserSchema