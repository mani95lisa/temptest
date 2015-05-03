'use strict'

require './dict'
require './token'
require './user'
require './manager'
require './lottery_record'
Mongoose = require 'mongoose'

module.exports =
  Manager : Mongoose.model 'ProyaManager'
  Dict : Mongoose.model 'ProyaDict'
  Token : Mongoose.model 'ProyaToken'
  User : Mongoose.model 'ProyaUser'
  LotteryRecord : Mongoose.model 'ProyaLotteryRecord'