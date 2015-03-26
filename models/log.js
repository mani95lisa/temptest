// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var LogSchema, Mongoose, Schema, request;

  Mongoose = require('mongoose');

  Schema = Mongoose.Schema;

  request = require('request');

  LogSchema = new Schema({
    ip: String,
    ip_address: String,
    action: String,
    value: String,
    manager: {
      type: Schema.Types.ObjectId,
      ref: 'Manager'
    },
    created_at: Date
  });

  LogSchema.pre('save', function(next) {
    var log;
    log = this;
    log.created_at = new Date();
    if (log.ip) {
      return request.get('http://api.map.baidu.com/location/ip?ak=AfKh7pndgGSZPwwdOXTIPB94&ip=' + log.ip, function(err, res, body) {
        if (!err) {
          log.ip_address = JSON.parse(body).address;
        }
        return next();
      });
    } else {
      return next();
    }
  });

  Mongoose.model('Log', LogSchema);

}).call(this);
