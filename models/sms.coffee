'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema

SMSSchema = new Schema
  mobile:Number
  content:String
  created_at:Date

Mongoose.model 'SMS', SMSSchema