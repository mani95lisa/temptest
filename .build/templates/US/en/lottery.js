(function(dust){dust.register("lottery",body_0);var blocks={"body":body_2};function body_0(chk,ctx){ctx=ctx.shiftBlocks(blocks);return chk.p("layouts/weixin_master",ctx,{}).w("<link rel=\"stylesheet\" href=\"css/lottery.css\"/><script type=\"text/javascript\">var appId = '';var count_down_time = parseInt('").f(ctx.get(["countdown"], false),ctx,"h").w("');var draw_url = '").f(ctx.get(["draw_url"], false),ctx,"h").w("';").s(ctx.get(["config"], false),ctx,{"block":body_1},{}).w("var shared_success = function(){_hmt.push(['_trackEvent', '大白活动1', '详情页分享', '").f(ctx.get(["uid"], false),ctx,"h").w("']);};wx.ready(function () {var wxData = {\"appId\":appId,\"title\" : '").f(ctx.get(["name"], false),ctx,"h").w("',\"desc\" : '").f(ctx.get(["desc"], false),ctx,"h").w("',\"imgUrl\" : '").f(ctx.get(["img"], false),ctx,"h").w("',\"link\" : $('#url').text(),success:shared_success};wx.onMenuShareAppMessage(wxData);wx.onMenuShareQQ(wxData);wx.onMenuShareWeibo(wxData);wx.onMenuShareTimeline({\"appId\":appId,\"title\" : '").f(ctx.get(["group_desc"], false),ctx,"h").w("',\"imgUrl\" : '").f(ctx.get(["img"], false),ctx,"h").w("',\"link\" : $('#url').text(),success:shared_success});});</script>").w("<script type=\"text/javascript\" src=\"js/lottery.js\"></script>");}body_0.__dustBody=!0;function body_1(chk,ctx){ctx=ctx.shiftBlocks(blocks);return chk.w("var arr = \"").f(ctx.getPath(false, ["config","jsApiList"]),ctx,"h").w("\";arr = arr.split(',');appId = \"").f(ctx.getPath(false, ["config","appId"]),ctx,"h").w("\";wx.config({debug:\"").f(ctx.getPath(false, ["config","debug"]),ctx,"h").w("\",appId: \"").f(ctx.getPath(false, ["config","appId"]),ctx,"h").w("\",timestamp: \"").f(ctx.getPath(false, ["config","timestamp"]),ctx,"h").w("\",nonceStr: \"").f(ctx.getPath(false, ["config","nonceStr"]),ctx,"h").w("\",signature: \"").f(ctx.getPath(false, ["config","signature"]),ctx,"h").w("\",jsApiList: arr});");}body_1.__dustBody=!0;function body_2(chk,ctx){ctx=ctx.shiftBlocks(blocks);return chk.w("<img class=\"bg\" src=\"imgs/lottery_bg.jpg\"><button id=\"button_mask\"></button><div id=\"joined\"><span class=\"joined_value\">").f(ctx.get(["joined"], false),ctx,"h").w("</span><span class=\"joined_label\">人已参与</span></div><div id=\"count_down\"><img id=\"time_bg\" src=\"imgs/time_bg.png\"><img id=\"num1\" src=\"imgs/0.png\"/><img id=\"num2\" src=\"imgs/0.png\"/><img id=\"num3\" src=\"imgs/0.png\"/><img id=\"num4\" src=\"imgs/0.png\"/><img id=\"num5\" src=\"imgs/0.png\"/><img id=\"num6\" src=\"imgs/0.png\"/><img id=\"num7\" src=\"imgs/0.png\"/><img id=\"num8\" src=\"imgs/0.png\"/><img id=\"time_lines\" src=\"imgs/lines.png\"></div><img id=\"need_know\" src=\"imgs/need_know.png\"><img id=\"rule\" src=\"imgs/rule.png\"><img id=\"red_line\" src=\"imgs/red_line.png\"><img id=\"need_know_detail\" src=\"imgs/need_know_detail.jpg\"><img id=\"rule_detail\" src=\"imgs/rule_detail.jpg\"><div style=\"display: none\" id=\"url\">").f(ctx.get(["url"], false),ctx,"h").w("</div>");}body_2.__dustBody=!0;return body_0;})(dust);