'use strict';

session = require('express-session');
MongoStore = require('connect-mongo')(session);

module.exports = (settings, MongoConfig) ->
  settings.store = new MongoStore(MongoConfig)
  return session(settings)