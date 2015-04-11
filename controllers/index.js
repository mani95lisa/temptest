// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var API, Dict, EventProxy, LINK_ERROR, Lottery, LotteryRecord, OAuth, SMS, SYSTEM_ERROR, TIME_OUT_ERROR, Token, UpdateObject, User, WEIXIN_AUTH_ERROR, api, appid, auth, client, code_url, errorHandler, getConfig, getParams, getRewardNumber, getToken, getUrl, getUserToken, get_js_sdk_ticket, home_url, host, inTime, logger, menu, models, moment, regist_url, request, saveToken, saveUserToken, save_js_sdk_ticket, secret, sign_in_url, utils;

  auth = require('../lib/auth');

  API = require('wechat-api');

  appid = 'wx1f9fe13fd3655a8d';

  secret = '2a3792094fc7e3b91a4920a8afb0a0c1';

  models = require('../models/index');

  User = models.User;

  Token = models.Token;

  Dict = models.Dict;

  Lottery = models.Lottery;

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

  host = 'http://rsct.swift.tf';

  home_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + host + '/init_auto&state=c___weixin;;p___lottery&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect';

  getUrl = function(channel, page) {
    return 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + host + '/init_auto&state=c___' + channel + ';;p___' + page + '&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect';
  };

  menu = {
    'button': [
      {
        name: '幸运石',
        type: 'view',
        url: 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx1f9fe13fd3655a8d&redirect_uri=http://rsct.swift.tf/init_auto&state=c___weixin;;p___lottery;;id___55212f6694bb4ca34251f8c1&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect'
      }, {
        name: '帮你赚钱',
        sub_button: [
          {
            type: 'view',
            name: '我的账户',
            url: 'http://www.rsct.com/finance/website/to_login.action'
          }, {
            name: '快速投资',
            type: 'view',
            url: 'http://www.rsct.com/finance/website/index.action'
          }
        ]
      }, {
        name: '关于润石',
        sub_button: [
          {
            type: 'view',
            name: '关于润石',
            url: 'http://www.rsct.com/finance/website/dima.action'
          }, {
            name: '呼叫小石头',
            type: 'click',
            key: 'call_kf'
          }
        ]
      }
    ]
  };

  getConfig = function(req, callback) {
    var url;
    url = host + req.url;
    return api.getJsConfig({
      debug: false,
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
    var init;
    init = function(req, res, result) {
      var ep, params, state, user;
      state = req.query.state;
      params = getParams(state);
      logger.trace('InitState:' + state);
      user = '';
      ep = new EventProxy();
      ep.on('ok', function(user) {
        return getConfig(req, function(err, config) {
          var id, page;
          if (err) {
            logger.error('ConfigError:' + err);
          }
          req.session.user = user;
          req.session.state = state;
          page = params.p;
          if (page === 'lottery') {
            id = params.id;
            if (!id) {
              return errorHandler(res, LINK_ERROR);
            } else {
              return Lottery.findById(id, function(err, result) {
                var begin, bg_url, countdown, data, detail_url, draw_url, plus, share_url, success_bg_url;
                if (err) {
                  return logger.error(err);
                } else if (result) {
                  plus = 0;
                  if (result.plus) {
                    plus = result.plus;
                  }
                  result.joined += plus;
                  share_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + host + '/init_auto&state=c___' + params.c + ';;p___' + params.p + ';;id___' + id + '&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect';
                  countdown = moment(result.end).valueOf() - moment().valueOf();
                  begin = moment().valueOf() - moment(result.begin).valueOf();
                  draw_url = '/draw_lottery';
                  success_bg_url = result.success_bg_url ? result.success_bg_url : 'imgs/success_bg.jpg';
                  req.session.shareInfo = {
                    success_bg_url: success_bg_url,
                    begin: result.begin,
                    end: result.end,
                    name: result.name,
                    group_desc: result.group_desc,
                    desc: result.description,
                    img: result.thumb,
                    url: share_url
                  };
                  detail_url = result.detail_url ? result.detail_url : 'imgs/need_know_detail.jpg';
                  bg_url = result.bg_url ? result.bg_url : 'imgs/lottery_bg.jpg';
                  data = {
                    begin: begin,
                    uid: user._id,
                    draw_url: draw_url,
                    detail_url: detail_url,
                    bg_url: bg_url,
                    joined: result.joined,
                    config: config,
                    desc: result.description,
                    group_desc: result.group_desc,
                    url: share_url,
                    img: result.thumb,
                    countdown: countdown,
                    name: result.name
                  };
                  return res.render('lottery', data);
                }
              });
            }
          } else {
            return errorHandler(res, LINK_ERROR);
          }
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
    router.get('/menu', function(req, res) {
      return api.createMenu(menu, function(err, result) {
        if (err) {
          logger.error(err);
          return res.json({
            err: err
          });
        } else {
          logger.trace('menu setted:', result);
          return api.getMenu(function(err, result) {
            return res.json(result);
          });
        }
      });
    });
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
      return res.render('login');
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
                share_url: 'http://rsct.swift.tf' + req.url,
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
      return res.render('lottery', {
        draw_url: '/draw_lottery',
        joined: moment().format('YYMMDD'),
        countdown: 94170370
      });
    });
    router.get('/draw_lottery', function(req, res) {
      var params, session, shareInfo, state, user;
      session = req.session;
      user = session.user;
      state = session.state;
      shareInfo = req.session.shareInfo;
      if (!user || !state) {
        console.log('Error1:');
        return errorHandler(res, TIME_OUT_ERROR);
      } else if (user.mobile) {
        params = getParams(state);
        return getConfig(req, function(err, config) {
          var begin, countdown;
          shareInfo.config = config;
          countdown = moment(shareInfo.end).valueOf() - moment().valueOf();
          begin = moment().valueOf() - moment(shareInfo.begin).valueOf();
          if (begin < 0) {
            return errorHandler(res, '活动尚未开始，请稍候再试');
          } else {
            return LotteryRecord.find({
              lottery: params.id,
              user: user._id
            }, function(err, result) {
              var arr;
              console.log('CD:' + countdown + ' B:' + begin);
              if (result && result.length) {
                arr = [];
                result.forEach(function(r) {
                  var status;
                  if (r.status) {
                    status = '已中奖';
                  } else {
                    status = countdown > 0 ? '未开奖' : '未中奖';
                  }
                  return arr.push({
                    value: r.number,
                    status: status
                  });
                });
                shareInfo.nums = arr;
                shareInfo.uid = user._id;
                return res.render('success', shareInfo);
              } else if (countdown > 0) {
                return getRewardNumber(params.id, user._id, user.openid, function(err, result) {
                  if (err) {
                    console.log('Error2:');
                    return errorHandler(res, SYSTEM_ERROR);
                  } else {
                    arr = [
                      {
                        value: result,
                        status: '未开奖'
                      }
                    ];
                    shareInfo.nums = arr;
                    shareInfo.uid = user._id;
                    Lottery.findByIdAndUpdate(params.id, {
                      $inc: {
                        joined: 1
                      }
                    }, function(err, result) {
                      if (err) {
                        return logger.error('RecordLotterJoinErr:' + err);
                      } else {
                        return logger.warn('LotteryJoinedRecord:' + params.id + '-' + arr[0].value + '-' + user._id);
                      }
                    });
                    return res.render('success', shareInfo);
                  }
                });
              } else {
                return errorHandler(res, '您没有参与此次活动，请关注润石创投公众号，获取最新活动动态');
              }
            });
          }
        });
      } else {
        return res.render('sign_up');
      }
    });
    router.get('/shared_lottery', function(req, res) {
      var params, session, shareInfo, state, user;
      session = req.session;
      user = session.user;
      state = session.state;
      shareInfo = req.session.shareInfo;
      if (!user || !state) {
        return errorHandler(res, TIME_OUT_ERROR);
      } else if (!user.registered) {
        params = getParams(state);
        return getConfig(req, function(err, config) {
          shareInfo.config = config;
          return LotteryRecord.find({
            lottery: params.id,
            user: user._id
          }, function(err, result) {
            var arr, ep;
            if (result.length === 3) {
              arr = [];
              result.forEach(function(r) {
                var status;
                status = r.status ? '已中奖' : '未开奖';
                return arr.push({
                  value: r.number,
                  status: status
                });
              });
              shareInfo.nums = arr;
              shareInfo.uid = user._id;
              return res.render('success', shareInfo);
            } else if (result.length === 1) {
              ep = new EventProxy();
              ep.all('n1', 'n2', function(n1, n2) {
                arr = [
                  {
                    value: result[0].number,
                    status: '未开奖'
                  }
                ];
                arr.push({
                  value: n1,
                  status: '未开奖'
                });
                arr.push({
                  value: n2,
                  status: '未开奖'
                });
                shareInfo.nums = arr;
                shareInfo.uid = user._id;
                return res.render('success', shareInfo);
              });
              ep.fail(function(err) {
                logger.error(err);
                return errorHandler(res, SYSTEM_ERROR);
              });
              getRewardNumber(params.id, user._id, user.openid, ep.done('n1'));
              return getRewardNumber(params.id, user._id, user.openid, ep.done('n2'));
            }
          });
        });
      }
    });
    router.post('/verify_code', function(req, res) {
      var mobile;
      mobile = req.body.mobile;
      if (!mobile) {
        return res.json({
          err: '手机号不能为空'
        });
      } else {
        return request.post(code_url, {
          form: {
            mobileNo: mobile
          }
        }, function(err, result, body) {
          if (err) {
            return res.json({
              err: err
            });
          } else {
            body = JSON.parse(body);
            if (body.result === '1') {
              return res.json({
                err: body.tip
              });
            } else {
              return res.json({
                result: true
              });
            }
          }
        });
      }
    });
    router.get('/sign_up', function(req, res) {
      return res.render('sign_up');
    });
    router.post('/code', function(req, res) {
      return console.log(req.body);
    });
    router.post('/do_sign_in', function(req, res) {
      var data, formData, user;
      data = req.body;
      user = req.session.user;
      if (!user) {
        errorHandler(res, TIME_OUT_ERROR);
        return;
      }
      logger.trace('DoSignInSessionUser:' + JSON.stringify(user));
      if (!data.mobile) {
        return res.json({
          err: '请输入手机号'
        });
      } else if (!data.password) {
        return res.json({
          err: '请输入密码'
        });
      } else {
        formData = {
          form: {
            nickName: data.mobile,
            password: data.password
          }
        };
        logger.trace('DoSignSignIn:' + JSON.stringify(formData));
        return request.post(sign_in_url, formData, function(err, result, body) {
          if (err) {
            return res.json({
              err: err
            });
          } else {
            body = JSON.parse(body);
            logger.trace('Registered:' + JSON.stringify(body));
            if (body.result === '1') {
              return res.json({
                err: body.tip
              });
            } else {
              if (user) {
                return User.findByIdAndUpdate(user._id, {
                  $set: {
                    mobile: data.mobile
                  }
                }, function(err, result) {
                  if (err) {
                    logger.error('UserSetMobileError:' + user._id + '-' + data.mobile + '-' + err);
                  } else {
                    logger.warn('UserSetMobileOK:' + user._id + '-' + data.mobile);
                    req.session.user = result;
                  }
                  return res.json({
                    result: true
                  });
                });
              } else {
                return res.json({
                  result: true
                });
              }
            }
          }
        });
      }
    });
    router.post('/do_sign_up', function(req, res) {
      var data, formData, nickname, user;
      data = req.body;
      user = req.session.user;
      if (!user) {
        errorHandler(res, TIME_OUT_ERROR);
        return;
      }
      logger.trace('DoSignUpSessionUser:' + JSON.stringify(user));
      if (data.nickname) {
        nickname = data.nickname;
      } else if (user) {
        nickname = user.nickname;
      }
      if (!data.mobile) {
        return res.json({
          err: '请输入手机号'
        });
      } else if (!data.code) {
        return res.json({
          err: '请输入验证码'
        });
      } else if (!data.password) {
        return res.json({
          err: '请输入密码'
        });
      } else {
        formData = {
          form: {
            mobileNo: data.mobile,
            nickName: nickname,
            password: data.password,
            rePassword: data.password,
            verifyCode: data.code
          }
        };
        logger.trace('DoSignUp:' + JSON.stringify(formData));
        return request.post(regist_url, formData, function(err, result, body) {
          req.session.doing = false;
          if (err) {
            return res.json({
              err: err
            });
          } else {
            body = JSON.parse(body);
            logger.trace('Registered:' + JSON.stringify(body));
            if (body.result === '1') {
              return res.json({
                err: body.tip
              });
            } else {
              if (user) {
                return User.findByIdAndUpdate(user._id, {
                  $set: {
                    mobile: data.mobile
                  }
                }, function(err, result) {
                  if (err) {
                    logger.error('UserSetMobileError:' + user._id + '-' + data.mobile + '-' + err);
                  } else {
                    logger.warn('UserSetMobileOK:' + user._id + '-' + data.mobile);
                    req.session.user = result;
                  }
                  return res.json({
                    result: true
                  });
                });
              } else {
                return res.json({
                  result: true
                });
              }
            }
          }
        });
      }
    });
    router.post('/test', function(req, res) {
      return res.redirect('/draw_lottery');
    });
    router.post('/lottery_records/update', auth.isAuthenticated(), function(req, res) {
      var data;
      data = req.body;
      logger.trace('LotteryRecordUpdate:' + JSON.stringify(data));
      return LotteryRecord.findById(data._id).populate('user', 'openid mobile').populate('lottery', 'name').exec(function(err, result) {
        var diff, lname, mobile, openid;
        if (err) {
          logger.error('LRind:' + err);
          return res.json({
            err: err
          });
        } else {
          diff = UpdateObject(result, data, ['created_at', 'lottery', 'user', 'updated_at']);
          lname = result.lottery.name;
          openid = result.user.openid;
          mobile = result.user.mobile;
          return result.save(function(err, result) {
            var ep, msg, smsok, textok;
            if (err) {
              logger.error('LRUpdated:' + err);
              return res.json({
                err: err
              });
            } else {
              logger.warn('LRUpdated:' + diff);
              if (result.status) {
                textok = false;
                smsok = false;
                ep = new EventProxy();
                ep.all('text', 'sms', function() {
                  console.log('update', smsok, textok);
                  if (!textok && !smsok) {
                    return res.json({
                      err: '微信和短信通知均发送失败，请再试'
                    });
                  } else if (!textok) {
                    return res.json({
                      err: '发送微信通知失败，有可能是用户尚未关注服务号所致，但已发送短信通知'
                    });
                  } else if (!smsok) {
                    return res.json({
                      err: '发送短信通知失败，但已发送微信通知'
                    });
                  } else {
                    return res.json({
                      result: result
                    });
                  }
                });
                msg = '';
                if (result.notify) {
                  msg = '恭喜您于活动【' + lname + '】得到大白一只\n\n' + result.notify + '\n\n（请在润石创投服务号里发送【领取】两字完成领取流程）';
                } else {
                  msg = '恭喜您于活动【' + lname + '】得到大白一只\n（请在润石创投服务号里发送【领取】两字完成领取流程）';
                }
                api.sendText(openid, msg, function(err, text) {
                  if (err) {
                    logger.error('SendGotNotifyError:' + err);
                  } else {
                    textok = true;
                  }
                  return ep.emit('text');
                });
                msg = '感谢您参与活动【' + lname + '】并获得大白一只，（请在润石创投服务号里发送【领取】两字填写收货信息）';
                return SMS.send(mobile, msg, function(err, result) {
                  if (err) {
                    console.log('SMSSentErr:' + JSON.stringify(err));
                    logger.error('SendGotSMSError:' + err);
                  } else {
                    smsok = true;
                  }
                  return ep.emit('sms');
                });
              } else {
                return res.json({
                  result: result
                });
              }
            }
          });
        }
      });
    });
    router.get('/error', function(req, res) {
      return res.render('error', {
        error: 'test'
      });
    });
    router.get('/baecheck', function(req, res) {
      return res.json({
        status: true
      });
    });
    return router.get('/admin', auth.isAuthenticated(), function(req, res) {
      var nav;
      nav = [
        {
          path: 'dashboard',
          name: '仪表盘',
          icon: 'fa fa-dashboard'
        }, {
          path: 'lottery',
          name: '抽奖管理',
          icon: 'fa fa-list'
        }, {
          path: 'joined',
          name: '得奖管理',
          icon: 'fa fa-gift'
        }, {
          path: 'user',
          name: '用户管理',
          icon: 'fa fa-users'
        }, {
          path: 'sms',
          name: '短信记录',
          icon: 'fa fa-envelope'
        }, {
          path: 'setting',
          name: '系统设置',
          icon: 'fa fa-cogs'
        }
      ];
      return res.render('admin', {
        nav: nav
      });
    });
  };

}).call(this);
