function sticky_relocate(){var e=$(window).scrollTop(),t=$(".sidebar").offset().top;e>=148?$(".sidebar").hasClass("stick")||$(".sidebar").addClass("stick"):$(".sidebar").removeClass("stick");if(fromSideClick)return;$(".sidebar a").each(function(){var t=$(this),n=$(t.data("category"));n.position().top<=e+50?($(".sidebar li").removeClass("active"),t.parents("li").addClass("active")):$(this).parent().find(".media-body").html()!=$(".sidebar li").first().find(".media-body").html()&&t.parents("li").removeClass("active")})}function init(){$(".sidebar li").on("click",function(){fromSideClick=!0,$(".sidebar li").removeClass("active"),$(this).addClass("active"),$("body").stop().animate({scrollTop:$($(this).find("a").data("category")).offset().top},400,function(){fromSideClick=!1})}),$(".sidebar li").first().addClass("active"),$(".remove").on("click",function(){var e=$(this).parents(".table-view-cell.media"),t=e.find(".list-head"),n=e.data("id");t.find(".order-count").hide();var r=getIndexById(n);if(r>-1){var i=order.data[r],s=0,o=0;i.counts.forEach(function(e,t){s+=e.count,o+=e.price*e.count}),order.totalCount=order.totalCount-s,order.totalBill=order.totalBill-o,order.data.splice(r,1),$("#count").html(order.totalCount),$("#money").html(order.totalBill)}$(this).hide()}),$("#removeAll").on("click",function(){order.data=[],order.totalCount=0,order.totalBill=0,$(".list-op .btn.remove").hide(),$(".order-count").html("").hide(),$("#count").html(0),$("#money").html(0)}),$(".price").on("click",function(){var e=$(this).parents(".table-view-cell.media"),t=e.find(".list-head"),n=e.data("id"),r=e.find(".good-title").html(),i=$(this).data("type"),s=$(this).data("price"),o;order.totalCount+=1,order.totalBill+=+s;var u=getIndexById(n);if(u>-1)o=order.data[u],order.data[u].counts.forEach(function(e,t){e.type==i&&(e.count+=1)}),t.find("."+i).show().find("span").html(order.data[u][i]);else{var a={id:n,name:r,counts:[]};$(this).parents(".list-op").find(".btn.price").each(function(){a.counts.push({type:$(this).data("type"),count:i==$(this).data("type")?1:0,price:$(this).data("price")})}),order.data.push(a),o=a}$("#count").html(order.totalCount),$("#money").html(order.totalBill);var f="";o.counts.forEach(function(e,t){e.count!=0&&(f+=e.type+"<span> "+e.count+"</span>  ")}),t.find(".order-count").html(f).show(),$(this).parents(".list-op").find(".btn.remove").show(),$("#removeAll").show()}),$("#checkout").on("click",function(){var e="";order.data.forEach(function(t,n){var r=0,i="";t.counts.forEach(function(e,t){e.count!=0&&(r+=e.count*e.price,i+=e.type+'<span class="money"> '+e.count+"</span>  ")}),e+='<tr class="item-row"><td>'+t.name+"</td>"+"<td>"+i+"</td>"+'<td><span class="money">￥'+r+"</span></td>"+"</tr>"});if(order.totalBill==0){alert("您需要点击价格标签选择您需要的美食");return}$("#index-navbar,#index-view,.sidebar").hide(),$("#checkout-navbar,#checkout-view").show(),$("#bill-list").find(".item-row").remove(),$(e).insertBefore($("#bill-list .money-row")),$("#bill-sum").html("￥"+order.totalBill),$("#money2").html(order.totalBill),userData?fillForm(userData):$("#building").val()=="建外SOHO东区"?($("#east").show(),$("#east").removeAttr("disabled"),$("#west").hide(),$("#west").attr("disabled","disabled")):($("#east").hide(),$("#east").attr("disabled","disabled"),$("#west").show(),$("#west").removeAttr("disabled")),$("#building").change(function(){$(this).val()=="建外SOHO东区"?($("#west").hide(),$("#west").attr("disabled","disabled"),$("#east").show(),$("#east").removeAttr("disabled")):($("#east").hide(),$("#east").attr("disabled","disabled"),$("#west").removeAttr("disabled"),$("#west").show())})}),$("#back").on("click",function(){$("#index-navbar,#index-view,.sidebar").show(),$("#checkout-navbar,#checkout-view").hide(),$(".sidebar").removeClass("stick")}),$("#submit").on("click",function(){if(ordered){alert("您已成功下单，请关闭页面查看订单更新消息");return}var e={order:order,user:$("#user-form").serializeArray()},t=e.user,n={};n.total_fee=order.totalBill;var r=[];order.data.forEach(function(e){e.counts.forEach(function(t){t.count&&r.push({id:e.id,name:e.name,price:t.price,price_label:t.type,sum:t.count})})}),n.products=r;var i=[];t.forEach(function(e){e.name=="username"?n.contact=e.value:e.name=="phone"?n.mobile=e.value:e.name=="building"?i[0]=e.value:e.name=="floor"?i[1]=e.value:e.name=="addr"?n.address=e.value:e.name=="note"&&(n.note=e.value)}),n.areas=i;if(!n.contact){alert("联系人不能为空");return}if(!n.mobile){alert("手机号不能为空");return}if(!n.areas){alert("所在地不能为空");return}if(!n.address){alert("详细地址不能为空");return}$.post("/order/add",n,function(e,t,n){e.err?alert(e.err):(ordered=!0,wx.closeWindow())})})}function fillForm(e){userData.truename||(userData.truename=""),userData.mobile||(userData.mobile=""),userData.address||(userData.address=""),$("#username").val(userData.truename),$("#phone").val(userData.mobile),$("#addr").val(userData.address);var t="",n="";userData.areas&&userData.areas.length==2&&(t=userData.areas[0],n=userData.areas[1]),$("#building").val(t),$("#building").val()=="建外SOHO东区"?($("#east").show(),$("#east").val(n),$("#west").hide()):($("#east").hide(),$("#west").val(n),$("#west").show())}function getIndexById(e){var t=-1;return order.data.forEach(function(n,r){n.id==e&&(t=r)}),t}function preSelect(e,t,n){$(".list .table-view-cell.media").each(function(r,i){if($(this).data("id")==e){$container=$(this),n.forEach(function(e){order.totalBill+=e.price*e.count,order.totalCount+=e.count}),order.data.push({id:e,name:t,counts:n});var s="";n.forEach(function(e,t){e.count!==0&&(s+=e.type+"<span>"+e.count+"</span>")}),$container.find(".order-count").html(s).show(),$container.find(".btn.remove").show()}}),$("#count").html(order.totalCount),$("#money").html(order.totalBill)}var order={totalCount:0,totalBill:0,data:[]},fromSideClick=!1,ordered=!1,locationData;$(function(){init(),$(window).scroll(sticky_relocate),sticky_relocate()});var last_ordered=$("#last_ordered").text();last_ordered&&last_ordered!="[]"?(last_ordered=JSON.parse(last_ordered),last_ordered.forEach(function(e){preSelect(e.id,e.name,e.detail)}),$("#removeAll").show()):$("#removeAll").hide();