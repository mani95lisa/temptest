moment = require 'moment'

#console.log moment('2015-3-233ss7 00:ss00:00', 'YYYY-MM-DD HH:mm:ss').isValid()
#console.log moment('07:00', 'mm:ss').valueOf() - moment('06:59', 'mm:ss').valueOf()
d = moment(moment().format('YYYY-MM-DD'))
console.log typeof d.toDate()