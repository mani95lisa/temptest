(function(){define(["console","humane"],function(e,t){return function(n,r){return e.group("dashboard"),r.get("/m/count").success(function(r){return e.log("GotCount",r),r.err?t.log(r.err):n.count=r}).error(function(t){return e.err(t)}),e.groupEnd()}})}).call(this);