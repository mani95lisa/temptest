'use strict';

require('coffee-script/register');
var express = require('express');
var kraken = require('kraken-js');

if(process.env.ENV == 'production'){
    var log4js = require('log4js');
    log4js.loadAppender('baev3-log');
    var options = {
        'user': 'DRh3SQUbdtLI5jjyVAzsKqQU',
        'passwd': 'Z2w4s6ujmMcA5Wp9wj7SdyoO5g2E2ZOV'
    }
    log4js.addAppender(log4js.appenders['baev3-log'](options));
}

var options, app;
app = module.exports = express();
options = require('./lib/spec')(app)
app.use(kraken(options));
app.on('start', function () {
    console.log('Application ready to serve requests.');
    console.log('Environment: %s', app.kraken.get('env:env'));
});