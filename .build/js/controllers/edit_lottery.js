(function(){define(["console","humane","moment"],function(e,t,n){return function(r,i,s,o){return e.group("edit_lottery"),e.log(s),r.data=angular.copy(s),r.title=s?"编辑 "+s.name:"新增抽奖活动",r.ok=function(){var i,u,a;return s=r.data,!s.name||!s.begin||!s.end?t.log("活动名称、起止时间、链接地址、分享描述均不能为空"):(a=!0,i=n(s.begin,"YYYY-MM-DD HH:mm:ss").isValid(),e.log(i,s.begin),u=n(s.end,"YYYY-MM-DD HH:mm:ss").isValid(),!i||!u?t.log("时间格式不对，需要是 2015-01-01 14:00:00 这样的"):o.close(s))},r.$watch("channel",function(){if(s._id)return r.link_url="https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx1f9fe13fd3655a8d&redirect_uri=http://rsct.swift.tf/init_auto&state=c||"+r.channel+";;p||lottery;;id||"+s._id+"&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect"}),r.channel="weixin",r.$apply(),r.copyChanelUrl=function(){return s._id?(r.link_url="https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx1f9fe13fd3655a8d&redirect_uri=http://rsct.swift.tf/init_auto&state=c||"+r.channel+";;p||lottery;;id||"+s._id+"&response_type=code&scope=snsapi_base&connect_redirect=1#wechat_redirect",t.log("渠道链接已经复制好，直接粘贴使用即可")):t.log("该功能需要活动保存一次后才可以使用")},r.cancel=function(){return o.dismiss("cancel")},e.groupEnd()}})}).call(this);