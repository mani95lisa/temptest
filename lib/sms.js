var sms = {};
var request = require('request');
var SMS = require('../models').SMS;
var parseXML = require('xml2js').parseString;

function getMessage(code){
    switch(code)
    {
        case 100:
            return '发送成功';
        case 101:
            return '验证失败';
        case 102:
            return '短信不足';
        case 103:
            return '操作失败';
        case 104:
            return '非法字符';
        case 105:
            return '内容过多';
        case 106:
            return '号码过多';
        case 107:
            return '频率过快';
        case 108:
            return '号码内容空';
        case 109:
            return '账号冻结';
        case 110:
            return '禁止频繁单条发送';
        case 111:
            return '系统暂定发送';
        case 120:
            return '系统升级';
    }
}

module.exports = {

    config:function(config){
      sms = config;
    },

    list: function(req, reply){
        console.log('Get SMS Recordes', req.query);
        SMS.list(req.query, function(err, result){
            if(err){
                console.error(err);
                reply({status: false, results: err.code});
            }else{
                reply({status: true, results: result});
            }
        })
    },

    sendByAdmin:function(req, reply){
        console.log('Goto Send SMS', req.payload);
        var data = req.payload;
        var mobiles=[];
        if(data.users)
        {
            var s = '['+data.users.toString()+']';
            console.log(s);
            var a1 = JSON.parse(s);
            data.users = a1;
        }
        data.users.forEach(function (o) {
            mobiles.push(o.mobile);
        });
        var mobile = mobiles.join(',');
        console.log('Send SMS to :', mobile);
        module.exports.send(mobile, data.content, function (result) {
            var admin = req.pre.admin;
            reply(result);
            if(result.status){
                data.users.forEach(function (o) {
                    var sms = new SMS({mobile: o.mobile, content: data.content, type: data.type, user: o._id, creator: admin});
                    sms.save();
                });
            }
        });
    },

    send: function (mobile, content, callback, time, mid) {
        request.post(sms.sendURL, {form:{action:"sendOnce",ac: sms.uid, authkey: sms.password, m: mobile, c: content, cgid:sms.cgid}}, function (error, res, body) {
            if(error){
                callback(error);
            }else{
                parseXML(body, function(err, result){
                    if(err){
                        callback(err);
                    }else{
                        result = result.xml;
                        if(result && result.$.result == 1){
                            var remain = result.Item[0].$.remain;
                            callback(null,{result:remain});
                        }else{
                            console.log(result)
                            callback('发送短信失败');
                        }
                    }
                })
            }
        });
    },

    left: function (callback) {
        request.get(sms.checkURL, function (error, res, body) {
            if(error){
                callback(error)
            }else if(!res){
                callback(null, 0);
            }else{
                parseXML(body, function(err, result){
                    if(err){
                        callback(err);
                    }else{
                        result = result.xml.Item
                        callback(null, result[0].$.remain * 10);
                    }
                });
            }
        });
    }
};
