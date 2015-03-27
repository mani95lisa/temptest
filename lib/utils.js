'use strict';

/**
 * User: mani
 * Date: 14-3-10
 * Time: PM6:39
 */
exports.randomString = function(len) {
    var buf = [],
        chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
        charlen = chars.length;

    for (var i = 0; i < len; ++i) {
        buf.push(chars[getRandomInt(0, charlen - 1)]);
    }

    return buf.join('');
};

function compareObjects(o1, o2){
    var same = true;

    console.log('Type:' + typeof o1);

    if(Array.isArray(o1)){
        if(o1 !== o2){
            if(o1 && o2){
                if(o1.length !== o2.length){
                    same = false;
                }else if(o1.length){
                    for(var i=0; i<o1.length; i++){
                        if(!compareObjects(o1[i], o2[i])){
                            same = false;
                            break;
                        }
                    }
                }
            }else{
                same = false;
            }
        }
    }else{
        same = o1 == o2;
    }

    return same;
}

exports.updateObject = function(result, data, excludeFields){
    var key;
    if(!excludeFields){
        excludeFields = [];
    }
    excludeFields.push('creator');
    var diff = []
    for(key in data){
        if(excludeFields.indexOf(key) === -1){
            if(!compareObjects(data[key],result[key])){
                result[key] = data[key];
                diff.push({key: key, ov: result[key], nv: data[key]});
            }
        }
    }
    return JSON.stringify(diff);
};

exports.verifyCode = function(){
    return getRandomInt(1000,9999);
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

exports.getRandomInt = getRandomInt;