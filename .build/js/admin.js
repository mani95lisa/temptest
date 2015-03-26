(function(){requirejs.config({paths:{console:"../components/console/console.min",angular:"../components/angular/angular","angular-route":"../components/angular-route/angular-route.min",humane:"../components/humane/humane.min",jquery:"../components/jquery/dist/jquery.min",bootstrap:"../components/bootstrap/dist/js/bootstrap.min","angular-cookie":"../components/angular-cookie/angular-cookie.min","angular-ui-grid":"../components/angular-ui-grid/ui-grid-stable",moment:"../components/moment/min/moment.min","angular-bootstrap":"../components/angular-bootstrap/ui-bootstrap-tpls.min","ng-tags-input":"../components/ng-tags-input/ng-tags-input.min"},shim:{angular:{exports:"angular"},"angular-cookie":["angular"],"angular-route":["angular"],"angular-ui-grid":["angular"],"angular-bootstrap":["angular"],jquery:["angular"],"ng-tags-input":["angular"]},priority:["console","jquery","angular","angular-cookie"],urlArgs:"v=1.0"}),require(["require","console","jquery","angular","angular-cookie"],function(e,t,n){return t.group("startup"),t.info("console",t),t.info("jquery",n),t.info("angular",angular),e(["admin_define","route/admin_routes"],function(e){return t.info("start"),t.info("app",e),e.init(),t.groupEnd()})})}).call(this);