(function(){define(["console","humane","moment"],function(e,t,n){return function(t,n,r,i){return e.group("edit_collection"),e.log(r),t.data=angular.copy(r),t.title="编辑 "+r.name,r.cover.indexOf("http://")===-1&&(t.data.cover=host+r.cover),t.$apply(),t.ok=function(){return i.close(t.data)},t.cancel=function(){return i.dismiss("cancel")},e.groupEnd()}})}).call(this);