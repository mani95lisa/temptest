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
        if(process.env.USER != 'mani'){
            url = conf;
            console.log('DB:' + url);
        }

//        mongoose.set('debug', true);

        var db = mongoose.connection;

        db.on('connecting', function() {
            console.log('connecting to MongoDB...');
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
            console.log('MongoDB connection opened!');
        });
        db.on('reconnected', function () {
            console.log('MongoDB reconnected!');
        });
        db.on('disconnected', function() {
            console.log('MongoDB disconnected!');
            connected = false;
            setTimeout(connectWithRetry, 5000);
        });
        connectWithRetry();
    }
};

var connectWithRetry = function() {
    mongoose.connect(url, function(err) {
        if (err) {
            console.error('Failed to connect to mongo on startup - retrying in 5 sec', err);
            if(!connected){
                setTimeout(connectWithRetry, 5000);
            }
        }
    });
};