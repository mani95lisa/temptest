// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var EventProxy, Log, Lottery, LotteryRecord, UpdateObject, auth, logger, models, moment;

  models = require('../../models');

  Lottery = models.Lottery;

  LotteryRecord = models.LotteryRecord;

  UpdateObject = require('../../lib/utils').updateObject;

  auth = require('../../lib/auth');

  EventProxy = require('eventproxy');

  Log = require('../../lib/log');

  moment = require('moment');

  logger = require('log4js').getDefaultLogger();

  module.exports = function(router) {
    router.post('/add', auth.isAuthenticated(), function(req, res) {
      var data, lottery;
      data = req.body;
      logger.trace(JSON.stringify(data));
      lottery = new Lottery(data);
      return lottery.save(function(err, result) {
        if (err) {
          logger.error(err);
          return res.json({
            err: err
          });
        } else {
          return res.json({
            result: result
          });
        }
      });
    });
    router.post('/update', auth.isAuthenticated(), function(req, res) {
      var data;
      data = req.body;
      logger.trace(JSON.stringify(data));
      return Lottery.findById(data._id, function(err, result) {
        var diff;
        if (err) {
          logger.error('PFind:' + err);
          return res.json({
            err: err
          });
        } else {
          diff = UpdateObject(result, data, ['created_at', 'joined']);
          return result.save(function(err, result) {
            if (err) {
              logger.error('PUpdate:' + err);
              return res.json({
                err: err
              });
            } else {
              Log.record(req, req.originalUrl, diff);
              return res.json({
                result: result
              });
            }
          });
        }
      });
    });
    router.get('/name_list', auth.isAuthenticated(), function(req, res) {
      return Lottery.find({
        enabled: true
      }, 'name', function(err, result) {
        if (err) {
          return res.json({
            err: err
          });
        } else {
          return res.json({
            result: result
          });
        }
      });
    });
    return router.get('/list', auth.isAuthenticated(), function(req, res) {
      var data, ep, options, query;
      data = req.query;
      ep = new EventProxy();
      ep.all('count', 'result', function(count, result) {
        return res.json({
          count: count,
          result: result,
          pageSize: data.pageSize
        });
      });
      ep.fail(function(err) {
        logger.error(err);
        return res.json({
          err: err
        });
      });
      if (!data.pageSize) {
        data.pageSize = 10;
      }
      options = {
        sort: {
          created_at: -1
        }
      };
      if (data.page) {
        options.skip = (data.page - 1) * data.pageSize;
        options.limit = data.pageSize;
      }
      query = {};
      if (data.keywords) {
        query = {
          name: new RegExp(data.keywords, 'i')
        };
      }
      Lottery.find(query, null, options, ep.done('result'));
      return Lottery.count(query, ep.done('count'));
    });
  };

}).call(this);
