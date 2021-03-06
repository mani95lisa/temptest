'use strict'

Mongoose = require 'mongoose'
Schema = Mongoose.Schema
Bcrypt = require 'bcrypt'
SALT_WORK_FACTOR = 10
MAX_LOGIN_ATTEMPTS = 5
LOCK_TIME = 2 * 60 * 60 * 1000

ManagerSchema = new Schema
  username:type:String, required:true, index:unique:true
  password:type:String, required:true
  email:type:String, index:{unique:true,sparse:true}
  mobile:type:Number, index:{unique:true,sparse:true}
  role:String
  functions:[String]
  loginAttempts:type:Number,'default':0
  lockUntil:Number
  last_login:Date
  signed_in_times:type:Number,'default':1
  disabled:type:Boolean,'default':false
  creator:type:Schema.Types.ObjectId,ref:'Manager'
  updator:type:Schema.Types.ObjectId,ref:'Manager'

ManagerSchema.virtual('isLocked').get ->
  return !!(this.lockUntil && this.lockUntil > Date.now())

Timestamps = require('mongoose-times')
ManagerSchema.plugin Timestamps, created:'created_at', lastUpdated:'updated_at'

ManagerSchema.pre 'save', (next)->
  client = this
  if !client.isModified 'password'
    return next()
  Bcrypt.genSalt SALT_WORK_FACTOR, (err, salt)->
    if err
      return next err
    Bcrypt.hash client.password, salt,(err, hash)->
      if err
        return next err
      client.password = hash
      next()

ManagerSchema.methods.comparePassword = (password, callback)->
  Bcrypt.compare password, this.password, (err, isMatch)->
    if err
      callback err
    else
      callback null, isMatch

ManagerSchema.methods.incLoginAttempts = (callback)->
  if this.lockUntil && this.lockUntil < Date.now()
    return this.update
      $set:loginAttempts:1
      $unset:lockUntil:1
      callback
  update = $inc:loginAttempts:1
  if this.loginAttempts + 1 >= MAX_LOGIN_ATTEMPTS && !this.isLocked
    update.$set =lockUntil:Date.now()+LOCK_TIME
  return this.update update, callback

ManagerSchema.statics =
  getAuthenticated : (usernameOrMobileOrEmail, password, callback)->
    query = {}
    if usernameOrMobileOrEmail.indexOf('@') != -1
      query.email = usernameOrMobileOrEmail
    else if parseInt(usernameOrMobileOrEmail) > 0 && usernameOrMobileOrEmail.length == 11
      query.mobile = usernameOrMobileOrEmail
    else
      query.username = usernameOrMobileOrEmail
    this.findOne query, (err, result)->
      if err
        return callback err
      return callback '用户不存在' unless result
      result.comparePassword password, (err, isMatch)->
        if err
          return callback err
        if isMatch
          return callback '抱歉，您的账号已被禁用，请联系管理人员' if result.disabled
          result.last_login_time = new Date()
          result.signed_in_times++
          if !result.loginAttempts && !result.lockUntil
            result.save()
            callback null, result
          else
            result.loginAttempts = 0
            result.lockUntil = 0
            result.save (err, result)->
              if err
                return callback err
              callback null, result
        else
          if result.isLocked
            return result.incLoginAttempts (err)->
              if err
                return callback err
              else
                callback '您密码错误超过限制，已禁止登录，请联系客服'
          result.incLoginAttempts (err)->
            if err
              return callback err
            callback '密码错误'

Mongoose.model 'ProyaManager', ManagerSchema