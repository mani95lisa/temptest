// Generated by CoffeeScript 1.8.0
(function() {
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

}).call(this);
