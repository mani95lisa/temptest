/**
 * Created by mani on 14/11/20.
 */

var bytesToSize;

bytesToSize = function(bytes) {
    var i, sizes;
    sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    if (bytes === 0) {
        return '0';
    }
    i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)));
    return Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i];
};

var host = 'http://dida.qiniudn.com/';

var getDict = function(http, key, callback){
    http.get('/dict/get', {params: {key: key}}).success(function (result) {
        if (!result.err)
            callback(result.result);
        else
            alert(result.err);
    });
}

var getTime = function(seconds) {
    var hours = parseInt( seconds / 3600 ) % 24;
    var minutes = parseInt( seconds / 60 ) % 60;
    var seconds = Math.round(seconds % 60);
    return (hours < 10 ? "0" + hours : hours) + ":" + (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds  < 10 ? "0" + seconds : seconds);
}