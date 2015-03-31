'use strict';

session = require('express-session');
RedisStore = require('connect-redis')(session);

module.exports = (settings, redisConfig) ->
  settings.store = new RedisStore(redisConfig)
  return session(settings)