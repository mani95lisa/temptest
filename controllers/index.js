// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var API, Dict, EventProxy, LINK_ERROR, LotteryRecord, OAuth, SMS, SYSTEM_ERROR, TIME_OUT_ERROR, Token, UpdateObject, User, WEIXIN_AUTH_ERROR, api, appid, auth, client, code_url, errorHandler, getConfig, getParams, getRewardNumber, getToken, getUrl, getUserToken, get_js_sdk_ticket, home_url, host, inTime, logger, models, moment, regist_url, request, saveToken, saveUserToken, save_js_sdk_ticket, secret, sign_in_url, utils;

  auth = require('../lib/auth');

  API = require('wechat-api');

  appid = 'wx91e339282bcd9aa6';

  secret = '7d5c869ddbacd15c9f9646a70b3951e9';

  models = require('../models/index');

  User = models.User;

  Token = models.Token;

  Dict = models.Dict;

  LotteryRecord = models.LotteryRecord;

  EventProxy = require('eventproxy');

  logger = require('log4js').getDefaultLogger();

  request = require('request');

  moment = require('moment');

  utils = require('../lib/utils');

  UpdateObject = utils.updateObject;

  SMS = require('../lib/sms');

  OAuth = require('wechat-oauth');

  getToken = function(cb) {
    return Token.findOne({
      appid: appid
    }, function(err, result) {
      if (err) {
        logger.error('GetTokenError:' + err);
        return cb(null, null);
      } else if (result) {
        if (new Date().getTime() - result.get_ts.getTime() < 300000) {
          return cb(null, {
            accessToken: result.token
          });
        } else {
          return cb(null, null);
        }
      } else {
        return cb(null, null);
      }
    });
  };

  saveToken = function(token, cb) {
    return Token.findOne({
      appid: appid
    }, function(err, result) {
      if (err) {
        cb(null, null);
        return logger.error('SaveTokenError:' + err);
      } else if (result && result.token) {
        result.token = token.accessToken;
        result.get_ts = new Date();
        return result.save(cb);
      } else {
        token = new Token({
          appid: appid,
          secret: secret,
          token: token.accessToken,
          get_ts: new Date()
        });
        return token.save(cb);
      }
    });
  };

  api = new API(appid, secret, getToken, saveToken);

  getUserToken = function(openid, callback) {
    console.log('GotoGetToken:' + openid);
    return User.findOne({
      openid: openid
    }, 'openid access_token refresh_token expires_in ac_created_at scope', function(err, result) {
      var data2;
      if (err) {
        logger.error('GetUserTokenError:' + err);
        return callback(err);
      } else if (result) {
        console.log('GetUserTokenResult:' + JSON.stringify(result));
        data2 = {
          openid: result.openid,
          access_token: result.access_token,
          refresh_token: result.refresh_token,
          expires_in: result.expires_in,
          create_at: result.ac_created_at,
          scope: result.scope
        };
        console.log('R3:' + JSON.stringify(data2));
        return callback(null, data2);
      } else {
        logger.warn('GetUserTokenError:No User');
        return callback(null, client.store[openid]);
      }
    });
  };

  saveUserToken = function(openid, token, callback) {
    console.log('SaveUserToken:' + openid + '-' + JSON.stringify(token));
    return User.findOne({
      openid: openid
    }, function(err, result) {
      if (err) {
        logger.error('FindUserTokenError:' + err);
        return callback(err);
      } else if (result) {
        result.access_token = token.access_token;
        result.ac_created_at = token.create_at;
        result.refresh_token = token.refresh_token;
        result.expires_in = token.expires_in;
        result.scope = token.scope;
        return result.save(function(err, result) {
          if (err) {
            logger.error('SaveUserTokenError:' + err);
            return callback(err);
          } else {
            logger.trace('SaveUserTokenOK:' + JSON.stringify(token));
            return callback(null);
          }
        });
      } else {
        logger.warn('SaveUserTokenError:No User By Openid');
        client.store[openid] = token;
        return callback(null);
      }
    });
  };

  client = new OAuth(appid, secret, getUserToken, saveUserToken);

  get_js_sdk_ticket = function(type, cb) {
    console.log('get js ticket', type);
    return Token.findOne({
      appid: appid
    }, function(err, result) {
      if (err) {
        logger.error('GetJSTicketError:' + err);
        return cb(null, null);
      } else if (result && result.js_ticket) {
        return cb(null, {
          ticket: result.js_ticket,
          expireTime: result.js_ticket_expireTime
        });
      } else {
        return cb(null, null);
      }
    });
  };

  save_js_sdk_ticket = function(type, ticket, cb) {
    console.log('save js ticket', type, ticket);
    return Token.findOne({
      appid: appid
    }, function(err, result) {
      var token;
      if (err) {
        logger.error('SaveJSTicketError:' + err);
        return cb(null, null);
      } else if (result) {
        result.js_ticket = ticket.ticket;
        result.js_ticket_expireTime = ticket.expireTime;
        return result.save(cb);
      } else {
        token = new Token({
          appid: appid,
          secret: secret,
          js_ticket: ticket.ticket,
          js_ticket_expireTime: ticket.expireTime
        });
        return token.save(cb);
      }
    });
  };

  api.registerTicketHandle(get_js_sdk_ticket, save_js_sdk_ticket);

  host = 'http://uv.proya.com';

  home_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + host + '/init_auto&scope=snsapi_base&connect_redirect=1#wechat_redirect';

  console.log('HomeURL:' + home_url);

  getUrl = function(channel, page) {
    return 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + host + '/init_auto&state=c___' + channel + ';;p___' + page + '&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect';
  };

  getConfig = function(req, callback) {
    var url;
    url = host + req.url;
    return api.getJsConfig({
      debug: true,
      jsApiList: ['onMenuShareTimeline', 'onMenuShareAppMessage', 'onMenuShareQQ', 'onMenuShareWeibo'],
      url: url
    }, function(err, result) {
      return callback(err, result);
    });
  };

  inTime = function(times) {
    var now, result;
    now = moment().valueOf();
    if (!times || !times.length) {
      return false;
    } else {
      result = false;
      times.forEach(function(t) {
        var e, s;
        s = moment(t.start, 'HH:mm').valueOf();
        e = moment(t.end, 'HH:mm').valueOf();
        if (s <= now && e >= now) {
          return result = true;
        }
      });
      return result;
    }
  };

  getParams = function(state) {
    var arr, params;
    params = {};
    arr = state.split(';;');
    arr.forEach(function(item) {
      var temp;
      temp = item.split('___');
      if (temp.length === 2) {
        return params[temp[0]] = temp[1];
      }
    });
    return params;
  };

  getRewardNumber = function(lottery_id, user, openid, callback) {
    var num;
    num = utils.getRandomInt(1000000, 9999999);
    return LotteryRecord.findOne({
      lottery: lottery_id,
      number: num
    }, function(err, result) {
      var lr;
      if (err) {
        logger.error(err);
        return callback(err);
      } else if (result) {
        return getRewardNumber(lottery_id, user, callback);
      } else {
        lr = new LotteryRecord({
          lottery: lottery_id,
          user: user,
          number: num,
          openid: openid
        });
        return lr.save(function(err, result) {
          if (err) {
            logger.error(err);
            return callback(err);
          } else {
            logger.warn('NumberSaved:' + lottery_id + '-' + openid + '-' + num);
            return callback(null, num);
          }
        });
      }
    });
  };

  code_url = 'http://www.rsct.com/finance/weixin/sendverifycode.action';

  regist_url = 'http://www.rsct.com/finance/weixin/register.action';

  sign_in_url = 'http://www.rsct.com/finance/weixin/login.action';

  errorHandler = function(res, errorString, redirect_url) {
    var es;
    es = errorString ? errorString : '抱歉，系统出错，请稍候再试';
    return res.render('error', {
      error: es,
      url: redirect_url
    });
  };

  LINK_ERROR = '抱歉，链接错误，请重新再试';

  SYSTEM_ERROR = '抱歉，系统出错，请稍候再试';

  WEIXIN_AUTH_ERROR = '抱歉，微信授权错误，请重新再试';

  TIME_OUT_ERROR = '抱歉，页面打开时间过长或连接丢失，请重新再试';

  module.exports = function(router) {
    var init, limit, ratio;
    init = function(req, res, result) {
      var ep, params, state, user;
      state = req.query.state;
      params = getParams(state);
      logger.trace('InitState:' + state);
      user = '';
      ep = new EventProxy();
      ep.on('ok', function(user) {
        return getConfig(req, function(err, config) {
          var data;
          if (err) {
            logger.error('ConfigError:' + err);
          }
          req.session.user = user;
          data = {
            config: config,
            share_url: home_url
          };
          return res.render('proya', data);
        });
      });
      return User.findOne({
        openid: result.openid
      }, function(err, userResult) {
        var arr;
        if (err) {
          logger.error('InitUserFindError:' + err);
          return errorHandler(res, SYSTEM_ERROR);
        } else if (userResult) {
          user = userResult;
          if (params.c) {
            user.channel = params.c;
            arr = user.channels ? user.channels : [];
            if (arr.indexOf(params.c) === -1) {
              arr.push(params.c);
              user.channels = arr;
            }
          }
          user.last_login = new Date();
          user.login_times++;
          user.nickname = result.nickname;
          user.sex = result.sex;
          user.province = result.province;
          user.city = result.city;
          user.country = result.country;
          user.headimgurl = result.headimgurl;
          return user.save(function(err, result) {
            logger.trace('UserInitFindAndUpdated:' + JSON.stringify(result));
            return ep.emit('ok', result);
          });
        } else {
          user = new User({
            openid: result.openid,
            last_login: new Date(),
            created_at: new Date()
          });
          user.nickname = result.nickname;
          user.sex = result.sex;
          user.province = result.province;
          user.city = result.city;
          user.country = result.country;
          user.headimgurl = result.headimgurl;
          return user.save(function(err, result) {
            if (err) {
              logger.error('UserInitSaveError:' + err);
              return errorHandler(res, SYSTEM_ERROR);
            } else {
              logger.trace('UserInitSaved:' + JSON.stringify(result));
              return ep.emit('ok', result);
            }
          });
        }
      });
    };
    router.get('/init_auto', function(req, res) {
      var data, headers;
      headers = req.headers;
      data = req.query;
      if (!data.code) {
        logger.error('InitAuto微信授权错误');
        errorHandler(res, WEIXIN_AUTH_ERROR);
        return;
      }
      logger.trace('Inited2:' + JSON.stringify(data));
      return client.getUserByCode(data.code, function(err, result) {
        if (err) {
          logger.warn('AutoInitError:' + err);
          return res.redirect('https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + host + '/init&response_type=code&scope=snsapi_userinfo&state=' + data.state + '&connect_redirect=1#wechat_redirect');
        } else {
          return init(req, res, result);
        }
      });
    });
    router.get('/init', function(req, res) {
      var data;
      data = req.query;
      if (!data.code) {
        logger.error('Init微信授权错误');
        errorHandler(res, WEIXIN_AUTH_ERROR);
        return;
      }
      logger.trace('Inited1:' + JSON.stringify(data));
      return client.getUserByCode(data.code, function(err, result) {
        if (err) {
          logger.error('InitError:' + err);
          return errorHandler(res, WEIXIN_AUTH_ERROR);
        } else {
          return init(req, res, result);
        }
      });
    });
    router.get('/', function(req, res) {
      return res.redirectTo('/w');
    });
    router.get('/test2', function(req, res) {
      return Order.find({}, {
        products: {
          $elemMatch: {
            name: req.query.name
          }
        }
      }, function(err, result) {
        return res.json({
          err: err,
          result: result
        });
      });
    });
    router.get('/tp', function(req, res) {
      return res.render('pages');
    });
    router.get('/pages', function(req, res) {
      var chanel, id;
      chanel = req.query.c ? req.query.c : 'weixin';
      id = req.query.id;
      if (!id) {
        return errorHandler(res, LINK_ERROR);
      } else {
        return getConfig(req, function(err, config) {
          return Lottery.findById(id, function(err, result) {
            var data, share_url;
            if (err) {
              logger.error(err);
              return errorHandler(res, SYSTEM_ERROR);
            } else if (result) {
              share_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + host + '/init_auto&state=c___' + chanel + ';;p___lottery;;id___' + id + '&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect';
              data = {
                config: config,
                desc: result.description,
                group_desc: result.group_desc,
                url: share_url,
                share_url: 'http://lottery.rsct.com' + req.url,
                img: result.thumb,
                name: result.name
              };
              return res.render('pages', data);
            } else {
              return errorHandler(res, LINK_ERROR);
            }
          });
        });
      }
    });
    router.get('/ttt', function(req, res) {});
    router.get('/success', function(req, res) {
      return res.render('success', {
        nums: [
          {
            value: 1111111,
            status: 'true'
          }
        ]
      });
    });
    router.get('/lottery', function(req, res) {
      var bg_url, detail_url;
      detail_url = 'imgs/need_know_detail_3.jpg';
      bg_url = 'imgs/lottery_bg.jpg';
      return res.render('lottery', {
        bg_url: bg_url,
        detail_url: detail_url,
        draw_url: '/draw_lottery',
        joined: moment().format('YYMMDD'),
        countdown: 94170370
      });
    });
    limit = {
      9: [10, 10, 10, 10],
      12: [15, 1, 1, 1],
      13: [15, 1, 1, 1],
      14: [7, 0, 0, 0],
      15: [7, 0, 0, 0],
      16: [1, 0, 0, 0],
      17: [1, 0, 0, 0],
      18: [4, 0, 0, 0],
      19: [15, 1, 0, 1],
      20: [15, 0, 0, 1],
      21: [7, 0, 0, 0],
      22: [7, 0, 0, 0],
      23: [1, 0, 0, 0],
      24: [1, 0, 0, 0],
      25: [2, 0, 0, 0],
      26: [1, 0, 0, 0],
      27: [1, 0, 0, 0]
    };
    ratio = [0.8, 0.7, 0.6, 0.5];
    router.post('/record_lottery', function(req, res) {
      var data, session;
      session = req.session;
      data = req.body;
      if (!session.lid || !data.lid) {
        res.json({
          err: '网络连接超时啦，请稍候再试或截图保留中奖证据并联系客服'
        });
        return;
      }
      return LotteryRecord.findById(data.lid, function(err, result) {
        if (err) {
          return res.json({
            err: '网络连接超时啦，请稍候再试或截图保留中奖证据并联系客服'
          });
        } else {
          result.truename = data.truename;
          result.mobile = data.mobile;
          result.email = data.email;
          return result.save(function(err, result) {
            if (err) {
              return res.json({
                err: '网络连接超时啦，请稍候再试或截图保留中奖证据并联系客服'
              });
            } else {
              return res.json({
                result: true
              });
            }
          });
        }
      });
    });
    router.get('/draw_lottery', function(req, res) {
      var gotid, limitObject, rm, session, today, user;
      session = req.session;
      user = session.user;
      if (!user) {
        console.log('no user:');
        return errorHandler(res, TIME_OUT_ERROR);
      } else {
        today = moment().format('YYYY-MM-DD');
        rm = Math.random();
        limitObject = limit[new Date().getDate()];
        gotid = '';
        ratio.forEach(function(r) {
          var lindex;
          lindex = ratio.indexOf(r);
          if (r > rm) {
            return gotid = lindex;
          }
        });
        if (gotid !== '') {
          return LotteryRecord.count({
            day: today,
            lottery: gotid
          }, function(err, result) {
            var lr;
            if (err) {
              return res.json({
                result: false
              });
            } else {
              if (limitObject && limitObject[gotid] >= result) {
                console.log('limited');
                return res.json({
                  result: false
                });
              } else {
                lr = new LotteryRecord({
                  openid: user.openid,
                  user: user._id,
                  day: today,
                  lottery: gotid
                });
                console.log('got:', gotid);
                return lr.save(function(err, result) {
                  if (err) {
                    return res.json({
                      result: false
                    });
                  } else {
                    session.lid = result._id;
                    session.lottery = {
                      result: gotid
                    };
                    return res.json({
                      result: {
                        lid: result._id,
                        lot: gotid
                      }
                    });
                  }
                });
              }
            }
          });
        } else {
          return res.json({
            result: false
          });
        }
      }
    });
    router.post('/like', function(req, res) {
      var data, session;
      session = req.session;
      data = req.body;
      if (!session.user) {
        res.json({
          result: false
        });
        return;
      }
      return Dict.findOneAndUpdate({
        key: "likes"
      }, data, {
        upsert: true
      }, function(err, result) {
        if (err) {
          return res.json({
            err: err
          });
        } else {
          return res.json({
            result: true
          });
        }
      });
    });
    router.get('/likes', function(req, res) {
      var data, session;
      session = req.session;
      data = req.query;
      if (!session.user || !data.id) {
        res.json({
          result: false
        });
        return;
      }
      return Dict.findOne({
        key: 'likes'
      }, function(err, result) {
        if (err) {
          return res.json({
            result: false
          });
        } else {
          return res.json({
            result: result.value
          });
        }
      });
    });
    router.post('/record_lottery', function(req, res) {
      var data, err, id, session;
      session = req.session;
      id = session.id;
      if (!session.user || !id) {
        res.render('error', {
          error: '您太长时间没操作了，请重新再试'
        });
        return;
      }
      data = req.body;
      err = '';
      if (!data.mobile || (data.mobile && data.mobile.length !== 11)) {
        err = '手机号码格式不对';
      } else if (!data.truename) {
        err = '收件人不能为空';
      } else if (!data.address) {
        err = '收货地址不能为空';
      }
      if (err) {
        res.render('error', {
          error: err
        });
      } else {
        return LotteryRecord.findById(id, function(err, result) {
          if (err) {
            return res.render('error', {
              error: '系统出问题了，请稍后再试'
            });
          } else {
            result.truename = data.truename;
            result.mobile = data.mobile;
            result.address = data.address;
            return result.save(function(err, result) {
              if (err) {
                return res.render('error', {
                  error: '系统出问题了，请稍后再试'
                });
              } else {
                return res.json({
                  status: true
                });
              }
            });
          }
        });
      }
    });
    router.get('/get_lottery', function(req, res) {
      var ep, session;
      session = req.session;
      if (!session.user) {
        res.json({
          status: false
        });
        return;
      }
      ep = new EventProxy();
      ep.all('limit', 'ratio', 'count', function(limit, ratio, count) {
        var lr, value;
        limit = limit.value;
        ratio = ratio.value;
        if (count >= limit) {
          return res.json({
            status: false,
            reason: 'f'
          });
        } else {
          value = Math.random();
          if (value > ratio) {
            lr = new LotteryRecord({
              user: session.user._id,
              openid: session.user.openid,
              day: moment().format('YYYY-MM-DD')
            });
            return lr.save(function(err, result) {
              if (err) {
                return res.json({
                  status: false,
                  err: err
                });
              } else {
                session.id = result._id;
                return res.json({
                  status: true
                });
              }
            });
          } else {
            return res.json({
              status: false,
              reason: 'n'
            });
          }
        }
      });
      ep.fail(function(err) {
        return res.json({
          status: false,
          err: err
        });
      });
      Dict.findOne({
        key: 'LotteryLimit'
      }, ep.done('limit'));
      Dict.findOne({
        key: 'LotteryRatio'
      }, ep.done('ratio'));
      return LotteryRecord.count({
        day: moment().format('YYYY-MM-DD')
      }, ep.done('count'));
    });
    router.get('/lucky', function(req, res) {
      return Dict.findOne({
        key: 'CurrentActivity'
      }, 'value', function(err, result) {
        if (result && result.value) {
          return res.redirect(result.value);
        } else {
          return errorHandler(res);
        }
      });
    });
    router.get('/baecheck', function(req, res) {
      return res.json({
        status: true
      });
    });
    router.get('/proya', function(req, res) {
      return res.render('proya');
    });
    return router.get('/admin', auth.isAuthenticated(), function(req, res) {
      var nav;
      nav = [
        {
          path: 'dashboard',
          name: '仪表盘',
          icon: 'fa fa-dashboard'
        }, {
          path: 'joined',
          name: '得奖管理',
          icon: 'fa fa-gift'
        }, {
          path: 'user',
          name: '用户管理',
          icon: 'fa fa-users'
        }
      ];
      return res.render('admin', {
        nav: nav
      });
    });
  };

}).call(this);
