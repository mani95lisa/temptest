'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

AnalysisSchema = new Schema
  channel:type:String,index:true
  openid:type:String,index:sparse:true
  path:type:String,index:true
  action:type:String,index:sparse:true
  ip:String
  created_at:Date

Mongoose.model 'Analysis', AnalysisSchema