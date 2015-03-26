'use strict'

Manager = require('../models').Manager
Dict = require('../models').Dict
LocalStrategy = require('passport-local').Strategy
log4js = require('log4js')
logger = log4js.getLogger('Auth')

exports.config = (settings)->
  return

exports.localStrategy = ->
  return new LocalStrategy (username, password, done) ->
    Manager.getAuthenticated username, password, (err, user, reason)->
      if(err)
        logger.error(err)
      if(!user)
        logger.warn('Login Failed:'+username+'-'+password+'-'+reason);
        return done(err, false, {message:reason});
      else
        logger.trace('Loged in:'+username)
      if user.role && !user.functions
        Dict.findOne key:user.role, (err, result)->
          if result && result.list
            user.functions = result.list
            user.save (err, result)->
              if err
                done '登录失败', null
              else
                done(null, user)
          else
            done(null, user)
      else
        done(null, user)

exports.isAuthenticated =  (role) ->
  return  (req, res, next)->
    if (!req.isAuthenticated())
      req.session.goingTo = req.originalUrl
      res.redirect('/')
    else
      if (role && req.user.role != role)
        res.status(401)
        res.render('errors/401')
      else
        next();

exports.serialize = (user, done)->
  done null, user.id

exports.deserialize = (id, done)->
  Manager.findById id, (err, result)->
    done null, result

exports.injectUser = ->
  return (req, res, next)->
    if req.isAuthenticated()
      user = req.user
      res.locals.user = user
    next()