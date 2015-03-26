var hd = {
    param: {},
    shareObj: null,
    isShared: false,
    data: null,
    initRenderData: function(a) {},
    getCodeStatus: function(a, e, d) {
        var b = "\u672a\u4e2d\u5956";
        if (a == 1) {
            if (d && d.length > 0) {
                for (var c = 0; c < d.length; c++) {
                    if (Number(e) === Number(d[c])) {
                        b = "\u606d\u559c\u4e2d\u5956";
                    }
                }
            } else {
                b = "\u672a\u4e2d\u5956";
            }
        } else {
            b = "\u672a\u5f00\u5956";
        }
        return b;
    },
    init: function() {
        hd.param.id = initData.id;
        hd.param.openid = initData.openid;
        hd.param.phone = initData.phone;
        $("#change").on("click", function(a) {
            a.preventDefault();
            hd.showMobInput(hd.param.phone);
            return;
        });
        $("#share").on("click", function() {
            hd.pop = Pop.set({
                contentId: "popShare",
                content: '<div class="shareContent"></div><div class="shareClose"></div>',
                btns: {
                    ".shareClose": function(a) {
                        hd.pop.hide();
                        hd.pop = null;
                    }
                }
            }).show();
            _paq.push(["trackEvent", "\u5206\u4eab", "click", hd.param.id]);
        });
        $("#open").on("click", function() {
            _paq.push(["trackEvent", "\u4e0b\u8f7d", "click", hd.param.id]);
        });
        setTimeout(function() {
            $(".wrapper").show();
            $(".loading").hide();
        }, 100);
        data.getShareConfig(hd.param, hd.getShareConfigBack);
    },
    formatCode: function(b) {
        var d = b;
        for (var a = 0; a < (8 - b.length); a++) {
            d = "0" + d;
        }
        return d;
    },
    showMobInput: function(a) {
        hd.pop = Pop.set({
            content: '<div class="mobInput"><div class="mobTxt">\u5f53\u524d\u62bd\u5956\u624b\u673a\u53f7\uff1a<span>' + a + '</span></div><input id="mobNum" type="tel" placeholder="\u8bf7\u8f93\u5165\u65b0\u7684\u624b\u673a\u53f7\u7801" maxlength="11"><div id="errMsg">\u60a8\u8f93\u5165\u7684\u624b\u673a\u53f7\u7801\u6709\u8bef</div><button id="mobConfirm">\u786e\u5b9a</button></div><div class="mobClose"></div>',
            btns: {
                "#mobConfirm": function(b) {
                    hd.handleMob(b);
                },
                ".mobClose": function(b) {
                    hd.pop.hide();
                    hd.pop = null;
                }
            }
        }).show();
    },
    handleMob: function(b) {
        var a = $(b.target),
            c = a.parent().find("#mobNum");
        hd.param.phone = c.val().replace(/[^\d]/g, "").slice(0, 11);
        if (hd.param.phone == "" || !com.isPhoneNum(hd.param.phone)) {
            $("#errMsg").css("visibility", "visible");
            return false;
        } else {
            $("#errMsg").css("visibility", "hidden");
        }
        data.updatePhone(hd.param, hd.updateBack);
    },
    updateBack: function(a) {
        if (a.result && a.status && !a.status.code) {
            hd.pop.hide();
        } else {
            $("#errMsg").text("\u670d\u52a1\u5668\u4f11\u606f\u4e00\u4f1a\uff0c\u8bf7\u4e0b\u6b21\u518d\u8bd5~").css("visibility", "visible");
        }
    },
    getShareConfigBack: function(a) {
        if (a.result && a.status && !a.status.code) {
            hd.shareObj = a.result;
        }
    },
    doShareBack: function(a) {
        if (a.result && a.status && !a.status.code) {
            var b = $("#prizeListDest");
            for (var c = 0; c < a.result.length; c++) {
                b.html(b.html() + '<p class="prize-item">' + a.result[c].formatCode + " <span>(\u672a\u5f00\u5956)</span></p>");
            }
            hd.isShared = true;
            $("#share").text("\u5206\u4eab\u7ed9\u597d\u53cb");
            _paq.push(["trackEvent", "\u5206\u4eab\u6210\u529f", "click", hd.param.id]);
        }
    },
    shareFriend: function() {
        if (hd.shareObj) {
            WeixinJSBridge.invoke("sendAppMessage", {
                appid: "wx11893ccc398396db",
                img_url: hd.shareObj.imgUrl,
                img_width: "256",
                img_height: "256",
                link: hd.shareObj.url,
                desc: hd.shareObj.content,
                title: hd.shareObj.title
            }, function(a) {
                if (/\:(confirm|ok)/i.test(a.err_msg)) {
                    if (!hd.isShared) {
                        data.doShare(hd.param, hd.doShareBack);
                        hd.isShared = true;
                    }
                }
            });
        }
    },
    shareTimeline: function() {
        if (hd.shareObj) {
            WeixinJSBridge.invoke("shareTimeline", {
                img_url: hd.shareObj.imgUrl,
                img_width: "640",
                img_height: "640",
                link: hd.shareObj.url,
                desc: hd.shareObj.content,
                title: hd.shareObj.title
            }, function(a) {
                if (/\:(confirm|ok)/i.test(a.err_msg)) {
                    if (!hd.isShared) {
                        data.doShare(hd.param, hd.doShareBack);
                        hd.isShared = true;
                    }
                }
            });
        }
    }
};
$(document).ready(function() {
    hd.init();
});
document.addEventListener("WeixinJSBridgeReady", function onBridgeReady() {
    WeixinJSBridge.on("menu:share:appmessage", function(a) {
        hd.shareFriend();
    });
    WeixinJSBridge.on("menu:share:timeline", function(a) {
        hd.shareTimeline();
    });
}, false);