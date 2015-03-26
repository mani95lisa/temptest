(function(){define(["console","humane","moment"],function(e,t,n){return function(r,i,s,o,u,a){var f,l,c,h;return e.group("product"),r.page=1,r.search=function(){return r.page=1,r.getData()},r.pageSize=10,r.pages=[10,25,50,100],f="新增",r.functions=[f],r.run=function(e){if(e===f)return l()},l=function(){var n;return n=o.open({templateUrl:"modals/product.html",controller:"EditProduct",backdrop:"static",resolve:{data:function(){return""}}}),n.result.then(function(n){return n._id?i.post("/m/product/update",n).success(function(n){return n.err?t.error(n.err):(t.log("更新成功"),e.log(n),r.getData())},function(){return e.log("dismiss")}):(e.log(n),i.post("/m/product/add",n).success(function(n){return n.err?t.log(n.err):(t.log("新增成功"),e.log(n),r.getData())},function(){return e.log("dismiss")}))})},r.footer="partials/grid/grid_footer.html",r.header="partials/grid/grid_header.html",r.$watch("pageSize",function(e){return r.getData()}),r.$watch("page",function(e){return r.getData()}),c=[],r.requesting=!1,r.externalScopes={edit:function(n){var s;return s=o.open({templateUrl:"modals/product.html",controller:"EditProduct",backdrop:"static",resolve:{data:function(){return n.entity}}}),s.result.then(function(n){return i.post("/m/product/update",n).success(function(n){return n.err?t.error(n.err):(t.log("更新成功"),e.log(n),r.getData())})},function(){return e.log("dismiss")})},enable:function(n){var s;return s=n.entity,s.enabled=!s.enabled,e.log(s.enabled),i.post("/m/product/update",s).success(function(n){return n.err?t.error(n.err):(t.log("更新成功"),e.log(n),r.getData())})},style:function(e){return e.entity.enabled?"btn btn-warn btn-flat btn-sm":"btn btn-success btn-flat btn-sm"},label:function(e){return e.entity.enabled?"禁用":"启用"}},h='<div style="text-align: left"><div class="btn-group" ng-disabled="getExternalScopes().requesting"> <button ng-click="getExternalScopes().edit(row)" class="btn btn-default btn-flat btn-sm">编辑</button> <button ng-click="getExternalScopes().enable(row)" ng-class="getExternalScopes().style(row)">{{ getExternalScopes().label(row) }}</button> </div></div>',r.gridOptions={enableSorting:!1,columnDefs:[{name:"产品名称",field:"name",enableSorting:!1},{name:"购买次数",field:"ordered",width:100,enableSorting:!1},{name:"分类",field:"category",width:100,enableSorting:!1},{name:"价格",field:"price",width:200,enableSorting:!1},{name:"创建时间",field:"created_at",width:200,enableSorting:!1},{name:"操作",field:"created_at",width:120,enableSorting:!1,cellTemplate:h}]},r.getData=function(){if(r.requesting)return;return r.requesting=!0,i.get("/m/product/list",{params:{page:r.page,pageSize:r.pageSize,keywords:r.keywords}}).success(function(i){return e.group("product"),e.log("GotProducts",i),e.groupEnd(),r.requesting=!1,i.err?t.log(i.err):(r.count=i.count,i.result&&i.result.forEach(function(e){var t,r;return r=e.prices,t=[],r.forEach(function(e){return t.push(e.label+"="+e.value)}),e.price=t.join(" "),e.created_at=n(e.created_at).format("YYYY-MM-DD HH:mm:ss")}),r.gridOptions.data=i.result)}).error(function(e){r.requesting=!1;if(e)return t.log(e)})},r.getData(),e.groupEnd()}})}).call(this);