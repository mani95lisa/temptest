(function(dust){dust.register("proya",body_0);var blocks={"body":body_2};function body_0(chk,ctx){ctx=ctx.shiftBlocks(blocks);return chk.p("layouts/weixin_master",ctx,{}).w("<link rel=\"stylesheet\" href=\"css/pages.css\"/><link rel=\"stylesheet\" href=\"libs/animate.min.css\"/><script type=\"text/javascript\" src=\"libs/easeljs-NEXT.min.js\"></script><script type=\"text/javascript\" src=\"libs/preloadjs-NEXT.min.js\"></script><link href=\"//vjs.zencdn.net/4.12/video-js.css\" rel=\"stylesheet\"><script src=\"//vjs.zencdn.net/4.12/video.js\"></script><script type=\"text/javascript\">var appId = '';").s(ctx.get(["config"], false),ctx,{"block":body_1},{}).w("var shared_success = function(){};wx.ready(function () {var wxData = {\"appId\":appId,\"title\" : '").f(ctx.get(["name"], false),ctx,"h").w("',\"desc\" : '").f(ctx.get(["desc"], false),ctx,"h").w("',\"imgUrl\" : '").f(ctx.get(["img"], false),ctx,"h").w("',\"link\" : $('#url').text(),success:shared_success};wx.onMenuShareAppMessage(wxData);wx.onMenuShareQQ(wxData);wx.onMenuShareWeibo(wxData);wx.onMenuShareTimeline({\"appId\":appId,\"title\" : '").f(ctx.get(["group_desc"], false),ctx,"h").w("',\"imgUrl\" : '").f(ctx.get(["img"], false),ctx,"h").w("',\"link\" : $('#url').text(),success:shared_success});});</script><script type=\"text/javascript\">var slideChange = '';var swiper1 = '';var sup;var sdown;var videoEnded;window.test = true;$(document).ready(function() {});this.windowWidth = $(window).width();this.windowHeight = $(window).height();this.scale = this.windowWidth/320;$('.arrow').css({'margin-left':-(67*this.scale)/2,width:67*this.scale,height:23*this.scale});</script>").w("<script type=\"text/javascript\" src=\"js/proya.js\"></script>");}body_0.__dustBody=!0;function body_1(chk,ctx){ctx=ctx.shiftBlocks(blocks);return chk.w("var arr = \"").f(ctx.getPath(false, ["config","jsApiList"]),ctx,"h").w("\";arr = arr.split(',');appId = \"").f(ctx.getPath(false, ["config","appId"]),ctx,"h").w("\";wx.config({debug:\"").f(ctx.getPath(false, ["config","debug"]),ctx,"h").w("\",appId: \"").f(ctx.getPath(false, ["config","appId"]),ctx,"h").w("\",timestamp: \"").f(ctx.getPath(false, ["config","timestamp"]),ctx,"h").w("\",nonceStr: \"").f(ctx.getPath(false, ["config","nonceStr"]),ctx,"h").w("\",signature: \"").f(ctx.getPath(false, ["config","signature"]),ctx,"h").w("\",jsApiList: arr});");}body_1.__dustBody=!0;function body_2(chk,ctx){ctx=ctx.shiftBlocks(blocks);return chk.w("<img src=\"imgs/loading.png\" id=\"loading-img\"><label id=\"loading-label\">100%</label><div><div class=\"section \" id=\"section0\" style=\"background-color: #ffffed\"><img class=\"arrow\" src=\"imgs/down-arrow.png\"></div><div class=\"section\" id=\"section1\"style=\"background-color: #ffffed\"><video style=\"position: absolute\" class=\" video video-js vjs-default-skin vjs-big-play-centered\"controls preload=\"auto\" width=\"0\" id=\"video\" onended=\"videoEnded()\"><source src=\"video/17.mp4\" type='video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"'></source></video><img class=\"arrow\" src=\"imgs/down-arrow.png\"></div><div class=\"section\" id=\"section2\" style=\"background-color: #ffffff\"><div id=\"p3c\"><div id=\"p3-m1\" class=\"slide\"></div><div id=\"p3-m2\" class=\"slide\"></div><div id=\"p3-m3\" class=\"slide\"></div><div id=\"p3-m4\" class=\"slide\"></div><div id=\"p3-m6\" class=\"slide\"></div><div id=\"p3-m7\" class=\"slide\"></div><div id=\"p3-m8\" class=\"slide\"></div><div id=\"p3-m9\" class=\"slide\"></div></div><label id=\"love-label\">0</label><img class=\"arrow\" src=\"imgs/down-arrow.png\"></div><div class=\"section\" id=\"section3\" style=\"background-color: #ffffff\"><img class=\"arrow\" src=\"imgs/down-arrow.png\"></div><div class=\"section\" id=\"section4\"style=\"background-color: #f2ebd1\"><div id=\"p5-i1\" class=\"slide\"></div><div id=\"p5-i2\" class=\"slide\"></div><div id=\"p5-i3\" class=\"slide\"></div><div id=\"p5-i4\" class=\"slide\"></div><div id=\"p5-i5\" class=\"slide\"></div><label id=\"p5-label\">下滑参与抽奖</label><img class=\"arrow\" src=\"imgs/down-arrow.png\"></div><div class=\"section\" id=\"section5\"style=\"background-color: #f2ebd1\"><form id=\"form\" class=\"p6p3\" style=\"display: none\"><div class=\"field\"><input id=\"truename\" type=\"text\" name=\"mobile\" placeholder=\"请输入姓名\"></div><div class=\"field\" id=\"mobile\"><input type=\"number\" name=\"code\" placeholder=\"请输入电话\"></div><div class=\"field\" id=\"email\"><input type=\"email\" name=\"password\" placeholder=\"请输入邮箱\"></div><input type=\"hidden\" id=\"csrf\" name=\"_csrf\" value=\"").f(ctx.get(["_csrf"], false),ctx,"h").w("\"/></form></div></div><div id=\"tip\" style=\"width: 100%;height:100%;background-color:#ffffff;position: absolute;top: 0;z-index: 1000\"></div><div id=\"tip2\" style=\"width: 100%;height:100%;background-color:#ffffff;position: absolute;top: 0;z-index: 1000\"></div><div id=\"tip3\" style=\"width: 100%;height:100%;background-color:#ffffff;position: absolute;top: 0;z-index: 1000\"></div><div style=\"display: none\" id=\"url\">").f(ctx.get(["share_url"], false),ctx,"h").w("</div>");}body_2.__dustBody=!0;return body_0;})(dust);