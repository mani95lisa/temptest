/**
 * User: mani
 * Date: 14-3-4
 * Time: PM5:55
 */
'use strict';
var mongoose = require('mongoose');
var url = 'mongodb://localhost/rsct';
var connected = false;

module.exports = {
    config: function (conf) {
        if(process.env.NODE_ENV === 'production'){
            url = conf;
        }

//        mongoose.set('debug', true);

        var db = mongoose.connection;

        db.on('connecting', function() {
        });

        db.on('error', function(error) {
            console.error('Error in MongoDb connection: ' + error);
            mongoose.disconnect();
        });
        db.on('connected', function() {
            console.log('MongoDB connected!');
            connected = true;
        });
        db.once('open', function() {
        });
        db.on('reconnected', function () {
        });
        db.on('disconnected', function() {
            connected = false;
            setTimeout(connectWithRetry, 5000);
        });
        connectWithRetry();
    }
};

var connectWithRetry = function() {
    if(url){
        mongoose.connect(url, function(err) {
            if (err) {
                console.error('Failed to connect to mongo on startup - retrying in 5 sec', err);
                if(!connected){
                    setTimeout(connectWithRetry, 5000);
                }
            }
        });
    }else{
        console.error('MongoDB url can not be null');
    }
};