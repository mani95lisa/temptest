(function(){var e;e=function(e){var t,n;return n=["Bytes","KB","MB","GB","TB"],e===0?"0":(t=parseInt(Math.floor(Math.log(e)/Math.log(1024))),Math.round(e/Math.pow(1024,t),2)+" "+n[t])}}).call(this);