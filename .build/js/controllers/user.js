(function(){define(["console","humane","moment"],function(e,t,n){return function(r,i,s,o,u,a){var f,l;return e.group("user"),r.page=1,r.search=function(){return r.page=1,r.getData()},r.pageSize=10,r.pages=[10,25,50,100],r.footer="partials/grid/grid_footer.html",r.header="partials/grid/grid_header.html",r.$watch("pageSize",function(e){return r.getData()}),r.$watch("page",function(e){return r.getData()}),f=[],r.requesting=!1,r.externalScopes={edit:function(n){var s;return s=o.open({templateUrl:"modals/user.html",controller:"EditUser",backdrop:"static",resolve:{data:function(){return n.entity}}}),s.result.then(function(n){return n._csrf=csrf,i.post("/user/update",n).success(function(n){return n.err?t.log(n.err):(t.log("更新成功"),e.log(n),r.getData())})},function(){return e.log("dismiss")})}},l='<div style="text-align: left"><div class="btn-group" ng-disabled="getExternalScopes().requesting"> <button ng-click="getExternalScopes().edit(row)" class="btn btn-default btn-flat btn-sm">编辑</button> </div></div>',r.gridOptions={enableSorting:!1,columnDefs:[{name:"注册号",field:"mobile",width:100,enableSorting:!1},{name:"收货号",field:"mobile2",width:100,enableSorting:!1},{name:"姓名",field:"truename",width:100,enableSorting:!1},{name:"昵称",field:"nickname",width:100,enableSorting:!1},{name:"收货地址",field:"address",enableSorting:!1},{name:"创建时间",field:"created_at",width:150,enableSorting:!1},{name:"操作",field:"created_at",width:120,enableSorting:!1,cellTemplate:l}]},r.getData=function(){if(r.requesting)return;return r.requesting=!0,i.get("/user/list",{params:{page:r.page,pageSize:r.pageSize,keywords:r.keywords}}).success(function(i){return e.group("user"),e.log("GotUser",i),e.groupEnd(),r.requesting=!1,i.err?t.log(i.err):(r.count=i.count,i.result&&i.result.forEach(function(e){return e.last_login=n(e.last_login).format("YY-MM-DD HH:mm:ss"),e.created_at=n(e.created_at).format("YY-MM-DD HH:mm:ss")}),r.gridOptions.data=i.result)}).error(function(e){r.requesting=!1;if(e)return t.log(e)})},r.getData(),e.groupEnd()}})}).call(this);