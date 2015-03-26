'use strict'

require './dict'
require './token'
require './user'
require './manager'
require './log'
require './lottery'
require './lottery_record'
Mongoose = require 'mongoose'

module.exports =
  Log : Mongoose.model 'Log'
  Manager : Mongoose.model 'Manager'
  Dict : Mongoose.model 'Dict'
  Token : Mongoose.model 'Token'
  User : Mongoose.model 'User'
  Lottery : Mongoose.model 'Lottery'
  LotteryRecord : Mongoose.model 'LotteryRecord'