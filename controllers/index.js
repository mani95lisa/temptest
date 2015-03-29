// Generated by CoffeeScript 1.8.0
(function() {
  'use strict';
  var API, Dict, EventProxy, Lottery, LotteryRecord, Token, UpdateObject, User, api, appid, auth, code_url, getConfig, getParams, getRewardNumber, getToken, getUrl, get_js_sdk_ticket, home_url, host, inTime, logger, menu, models, moment, regist_url, request, saveToken, save_js_sdk_ticket, secret, sign_in_url, utils;

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
        name: '我的账户',
        type: 'view',
        url: 'http://www.rsct.com/finance/website/to_login.action'
      }, {
        name: '帮你赚钱',
        type: 'view',
        url: 'http://www.rsct.com/finance/website/index.action'
      }, {
        name: '关于润石',
        type: 'view',
        url: 'http://www.rsct.com/finance/website/dima.action'
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

  module.exports = function(router) {
    var init;
    init = function(req, res, result) {
      var params, state;
      state = req.query.state;
      params = getParams(state);
      console.log('State:' + state + 'Page:' + params.p);
      return User.findOne({
        openid: result.openid
      }, function(err, userResult) {
        var ep, user;
        if (err) {
          logger.error('UserFindError:' + err);
          return res.json({
            err: err
          });
        } else {
          ep = new EventProxy();
          ep.on('ok', function() {
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
                  return res.json({
                    status: false
                  });
                } else {
                  return Lottery.findById(id, function(err, result) {
                    var countdown, data, draw_url, s, share_url;
                    if (err) {
                      return logger.error(err);
                    } else if (result) {
                      s = moment().format('YYMMDD');
                      result.joined += parseInt(s);
                      share_url = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + host + '/init_auto&state=c___' + params.c + ';;p___' + params.p + ';;id___' + id + '&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect';
                      countdown = moment(result.end).valueOf() - moment().valueOf();
                      console.log('CD:' + countdown);
                      draw_url = '/draw_lottery';
                      req.session.shareInfo = {
                        name: result.name,
                        group_desc: result.group_desc,
                        desc: result.description,
                        img: result.thumb,
                        url: share_url
                      };
                      data = {
                        uid: user._id,
                        draw_url: draw_url,
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
                return res.json({
                  status: false
                });
              }
            });
          });
          user = '';
          if (userResult) {
            user = userResult;
            user.last_login = new Date();
            user.login_times++;
            return user.save(function(err, result) {
              return ep.emit('ok');
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
                logger.error('UserSaveError:' + err);
                return res.json({
                  err: err
                });
              } else {
                logger.trace('UserSaved:' + JSON.stringify(result));
                return ep.emit('ok');
              }
            });
          }
        }
      });
    };
    router.get('/menu', function(req, res) {
      return api.createMenu(menu, function(err, result) {
        if (err) {
          return logger.error(err);
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
        res.jsonp({
          status: false
        });
        return;
      }
      console.log('Inited2:' + JSON.stringify(data));
      return request.get('https://api.weixin.qq.com/sns/oauth2/access_token?appid=' + appid + '&secret=' + secret + '&code=' + data.code + '&grant_type=authorization_code', function(err, result) {
        var access_token, openid, refresh_token;
        if (err) {
          logger.error('UserCodeError2:' + err);
          return res.json({
            status: false
          });
        } else {
          result = JSON.parse(result.body);
          console.log('Inited2Result:' + JSON.stringify(result));
          if (result.errcode) {
            logger.error('UserCodeError2:' + result.errmsg);
            return res.json({
              status: false
            });
          } else {
            access_token = result.access_token;
            refresh_token = result.refresh_token;
            openid = result.openid;
            if (!access_token) {
              logger.error('UserAccessToeknError:' + JSON.stringify(result));
              return res.json({
                status: false
              });
            } else {
              return request.get('https://api.weixin.qq.com/sns/userinfo?access_token=' + access_token + '&openid=' + openid + '&lang=zh_CN', function(err, result) {
                var reinit;
                reinit = function() {
                  return res.redirect('https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + appid + '&redirect_uri=' + host + '/init&response_type=code&scope=snsapi_userinfo&state=' + data.state + '&connect_redirect=1#wechat_redirect');
                };
                if (err) {
                  logger.error('UserCodeError3:' + err);
                  return reinit();
                } else {
                  result = JSON.parse(result.body);
                  if (result.errcode) {
                    logger.error('UserInfoError:' + result.errmsg);
                    return reinit();
                  } else {
                    logger.trace('Init:' + JSON.stringify(result));
                    return init(req, res, result);
                  }
                }
              });
            }
          }
        }
      });
    });
    router.get('/init', function(req, res) {
      var data;
      data = req.query;
      if (!data.code) {
        res.jsonp({
          status: false
        });
        return;
      }
      return request.get('https://api.weixin.qq.com/sns/oauth2/access_token?appid=' + appid + '&secret=' + secret + '&code=' + data.code + '&grant_type=authorization_code', function(err, result) {
        var access_token, openid, refresh_token;
        if (err) {
          logger.error('UserCodeError1:' + err);
          return res.jsonp({
            status: false
          });
        } else {
          result = JSON.parse(result.body);
          if (result.errcode) {
            logger.error('UserCodeError2:' + result.errmsg);
            return res.jsonp({
              status: false
            });
          } else {
            access_token = result.access_token;
            refresh_token = result.refresh_token;
            openid = result.openid;
            if (!access_token) {
              logger.error('UserAccessToeknError:' + JSON.stringify(result));
              return res.jsonp({
                status: false
              });
            } else {
              return request.get('https://api.weixin.qq.com/sns/userinfo?access_token=' + access_token + '&openid=' + openid + '&lang=zh_CN', function(err, result) {
                if (err) {
                  logger.error('UserCodeError3:' + err);
                  return res.jsonp({
                    status: false
                  });
                } else {
                  result = JSON.parse(result.body);
                  if (result.errcode) {
                    logger.error('UserInfoError:' + result.errmsg);
                    return res.jsonp({
                      status: false
                    });
                  } else {
                    return init(req, res, result);
                  }
                }
              });
            }
          }
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
    router.get('/pages', function(req, res) {
      var chanel, id;
      chanel = req.query.c ? req.query.c : 'weixin';
      id = req.query.id;
      if (!id) {
        return res.json({
          status: false
        });
      } else {
        return getConfig(req, function(err, config) {
          return Lottery.findById(id, function(err, result) {
            var data, share_url;
            if (err) {
              logger.error(err);
              return res.json({
                status: false
              });
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
              return res.json({
                status: false
              });
            }
          });
        });
      }
    });
    router.get('/ttt', function(req, res) {});
    router.get('/success', function(req, res) {
      return res.render('success');
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
        return res.json({
          status: false
        });
      } else if (user.mobile) {
        params = getParams(state);
        return getConfig(req, function(err, config) {
          shareInfo.config = config;
          return LotteryRecord.find({
            lottery: params.id,
            user: user._id
          }, function(err, result) {
            var arr;
            if (result && result.length) {
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
            } else {
              return getRewardNumber(params.id, user._id, user.openid, function(err, result) {
                if (err) {
                  return res.josn({
                    status: false
                  });
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
            }
          });
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
        return res.json({
          status: false
        });
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
                return res.json({
                  status: false
                });
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
      if (req.session.doing) {
        return;
      }
      req.session.doing = true;
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
    router.post('/do_sign_up', function(req, res) {
      var data, formData, nickname, user;
      data = req.body;
      user = req.session.user;
      if (data.nickname) {
        nickname = data.nickname;
      } else if (user) {
        nickname = user.nickname;
      }
      if (req.session.doing) {
        console.log('doing');
        return;
      }
      req.session.doing = true;
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
      return LotteryRecord.findById(data._id).populate('user', 'openid').populate('lottery', 'name').exec(function(err, result) {
        var diff, lname;
        if (err) {
          logger.error('LRind:' + err);
          return res.json({
            err: err
          });
        } else {
          diff = UpdateObject(result, data, ['created_at', 'lottery', 'user', 'updated_at']);
          lname = result.lottery.name;
          return result.save(function(err, result) {
            if (err) {
              logger.error('LRUpdated:' + err);
              return res.json({
                err: err
              });
            } else {
              logger.warn('LRUpdated:' + diff);
              if (result.status && result.notify) {
                return api.sendText(result.user.openid, '恭喜您于活动【' + lname + '】中奖\n\n' + result.notify + '\n\n（请在输入框输入【领奖】两字进入领奖流程）', function(err, result) {
                  if (err) {
                    logger.error('notify error:' + err);
                    return res.json({
                      err: '发送通知失败，请再试一次，有可能是用户尚未关注服务号所致'
                    });
                  } else {
                    return res.json({
                      result: result
                    });
                  }
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
