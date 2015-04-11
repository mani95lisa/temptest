#moment = require 'moment'
#
##console.log moment('2015-3-233ss7 00:ss00:00', 'YYYY-MM-DD HH:mm:ss').isValid()
##console.log moment('07:00', 'mm:ss').valueOf() - moment('06:59', 'mm:ss').valueOf()
#d = moment(moment().format('YYYY-MM-DD'))
#console.log typeof d.toDate()
#
#中奖号码结果：/，余44581，补足7位为4458100，加
n1 = 602450608161503
r1 = n1%50614

console.log r1
#
#r2 = 1025743

sms = require '../lib/sms'

#o = {
#  "uid":"1001@500883280001",
#  "password":"30250B31F881FA5D7F376485D11E6534",
#  "sendURL":"http://smsapi.c123.cn/OpenPlatform/OpenApi",
#  "checkURL":"http://smsapi.c123.cn/OpenPlatform/OpenApi?action=getBalance&ac=1001@500883280001&authkey=30250B31F881FA5D7F376485D11E6534"
#}
#
#sms.config(o)
#sms.left (err, result)->
#  console.log err, result