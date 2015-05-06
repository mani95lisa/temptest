$(document).ready(function () {
    W_Width = $(window).width();
    W_Height = $(window).height();
    var ratio = W_Width / W_Height;
    var step3_width = W_Width * 600 / 1524;
    var playing = false;

//第二页
    var p1default = $('#i1');
    var fnOut, fnOver;

    fnOver = function () {
        if ($(this).attr('clickable')) {
            $(this).addClass('onclick');
        }
        return $(this).addClass('active');
    };

    fnOut = function () {
        if ($(this).attr('clickable')) {
            $(this).removeClass('onclick');
        }
        return $(this).removeClass('active');
    };

    $('.front').hover(fnOver, fnOut);

// STEP 2

    function setTableHeight() {
        $('.w1').width(W_Width * 567 / 1524);
        $('.w2').width(W_Width * 277 / 1524);
        $('.w3').width(W_Width * 259 / 1524);
        $('.w4').width(W_Width * 308 / 1524);
        $('.w5').width(W_Width * 585 / 1524);
        $('.wb1').width(W_Width * 679 / 1524);

        W_Width = $(window).width();
        W_Height = $(window).height();
        ratio = W_Width / W_Height;
        if (ratio > $('#bg1').width() / $('#bg1').height()) {
            $('#bg1,#bg4').width(W_Width);
        } else {
            $('#bg1,#bg4').height(W_Height);
        }
        $('#bg4').width(W_Width);
        $('.img-i').each(function () {
            $(this).closest('.flip-container').css({
                width: $(this).width(),
                height: $(this).height()
            });
        });
        $('.flipper .img-i').click(function () {
            var arr = ['#i3', '#i4', '#i7', '#i8'];
            var id = $(this).attr('data-target');
            if (arr.indexOf(id) != -1) {
                p1default.animate({opacity: 0}, {
                    duration: 500, complete: function () {
                        $(id).animate({opacity: 1}, 500);
                    }
                })
                p1default = $(id);
            }
        })
        $('#small-list').css({
            'width': W_Width * 0.65,
            'top': $('#main-item-3 .bg').height() * 543 / 888
        })
        $('#small-list li img').css({
            'width': W_Width * 100 / 1524
        })
        setSmallImg();
        $('#step3').css({
            'left': (W_Width - step3_width) / 2,
            'width': step3_width
        });
    }

    $(window).scroll(function () {
        setTableHeight();
    });
    setInterval(function () {
        setTableHeight();
    }, 1000)
// setTableHeight();


    var index_a = 2;
    var p3scale = W_Height / 892;
    var bigw = 251 * p3scale;
    var bigh = 549 * p3scale;
    var p3bgw = 1525 * p3scale;
    var centerl = (step3_width - bigw) / 2;
    var centert = W_Height - 88 * p3scale - bigh;
    var zoomS = 0.38;
    var smallTop = centert + 0.91 * bigh - bigh * zoomS;
    var preleft = 0;

    var initP3 = function () {
        $('#bg3').css({height: W_Height, opaticy: 0});
        $('#p3i1').css({left: centerl + bigw - 60 * p3scale, top: centert + 63 * p3scale});
        $('#p3i2').css({left: centerl + bigw / 2, top: centert - 68 * p3scale});
        $('#p3i3').css({left: centerl + bigw - 90 * p3scale, top: centert + 404 * p3scale});
        $('#p3i4').css({left: centerl + 35 * p3scale, top: centert + 131 * p3scale});
        $('#p3i5').css({left: centerl + bigw - 100 * p3scale, top: centert + 420 * p3scale});
        for (var i = 0; i < 5; i++) {
            preleft = 0;
            if (i < index_a) {
                preleft = centerl - (80 * p3scale) - (38 + bigw * zoomS) * (index_a - i)
                $('.p3m').eq(i).css({width: bigw * zoomS, top: smallTop, left: preleft});
            } else if (i > index_a) {
                preleft = centerl + bigw - 80 * p3scale + (38 + bigw * zoomS) * (i - index_a);
                $('.p3m').eq(i).css({width: bigw * zoomS, top: smallTop, left: preleft});
            } else if (i == index_a) {
                console.log('big', bigw);
                $('.p3m').eq(index_a).css({opacity: 0, width: bigw, left: centerl, top: centert});
                $('.p3t').eq(index_a).css({left: (step3_width - 467) / 2});
                $('.p3i').eq(index_a).css({width: 123 * p3scale});
            }
            var o = $('.p3t').eq(i);
            var p3tw = 0;
            var p3iw = 0;
            if (i == 0) {
                p3tw = 358;
                p3iw = 142;
            }
            else if (i == 1) {
                p3tw = 395;
                p3iw = 122;
            } else if (i == 2) {
                //p3tw = 467;
                //p3iw = 123;
            } else if (i == 3) {
                p3tw = 397;
                p3iw = 182;
            } else if (i == 4) {
                p3tw = 507;
                p3iw = 146;
            }

            if (i != index_a) {
                o.css({left: (step3_width - p3tw) / 2});
                $('.p3i').eq(i).css({width: p3iw * p3scale});
            }
        }

    }


    initP3();

    var onLeave = function (index, nextIndex) {
        if (nextIndex == 3) {
            $('.p3t').eq(index_a).css({opacity: 0});
            $('.p3i').eq(index_a).css({opacity: 0});
            $('.p3m').css({opacity: 0});
            $('#bg3').css({opacity: 0});
            $('#bg3').animate({opacity: 1}, {
                duration: 1500, complete: function () {
                    $('.p3m').animate({opacity: 1}, {
                        duration: 1000, complete: function () {
                            $('.p3t').eq(index_a).animate({opacity: 1}, {
                                duration: 500, complete: function () {
                                    $('.p3i').eq(index_a).animate({opacity: 1}, {duration: 1000});
                                    $('#btn-left-a').animate({opacity: 1}, {duration: 1000});
                                    $('#btn-right-a').animate({opacity: 1}, {duration: 1000});
                                }
                            })
                        }
                    })
                }
            });
        } else if (nextIndex == 4) {
            $('#p4mask').css({opacity: 1});
            $('#p41').animate({opacity: 0}, {
                duration: 1500, complete: function () {
                    $('#p42').animate({opacity: 0}, {
                        duration: 1000, complete: function () {
                            $('#p43').animate({opacity: 0}, {
                                duration: 800, complete: function () {
                                    $('#p44').animate({opacity: 0}, {
                                        duration: 500, complete: function () {
                                            $('#p45').animate({opacity: 0}, {
                                                duration: 300, complete: function () {

                                                }
                                            });
                                        }
                                    });
                                }
                            });
                        }
                    });
                }
            });
        }
    };
    var index_s4 = 0;
    var s4l = $('.s4-img').css('left');
    var s4scale = W_Width / 1524;
    var s4w = W_Width - 2 * s4Left;
    var s4t = $('.s4-img').css('top');
    $('#p41').css({width: 289 * s4scale, height: 355 * s4scale, left: 100 * s4scale, top: 60 * s4scale});
    $('#p42').css({width: 273 * s4scale, height: 343 * s4scale, left: 110 * s4scale, top: 420 * s4scale});
    $('#p43').css({width: 295 * s4scale, height: 385 * s4scale, left: 390 * s4scale, top: 320 * s4scale});
    $('#p44').css({width: 373 * s4scale, height: 304 * s4scale, left: 720 * s4scale, top: 435 * s4scale});
    $('#p45').css({width: 295 * s4scale, height: 455 * s4scale, right: 90 * s4scale, top: 240 * s4scale});

    $('#btn-right-a').click(function () {
        if (playing) return;
        playing = true;
        setTimeout(function () {
            playing = false;
        }, 1000);
        var cur_index = index_a;
        if (index_a > 4) return;
        index_a++;
        var hidel = centerl - (80 * p3scale) - bigw * zoomS;
        for (var i = 0; i < 5; i++) {
            if (i == cur_index) {
                $('.p3i').eq(cur_index).animate({opacity: 0}, {duration: 500});
                $('.p3t').eq(cur_index).animate({opacity: 0}, {duration: 500});
                $('.p3m').eq(cur_index).animate({
                    left: hidel, width: bigw * zoomS, top: smallTop
                }, {
                    duration: 500, complete: function () {

                    }
                });
            } else if (i == index_a) {

                $('.p3m').eq(i).animate({
                    left: centerl, width: bigw, top: centert
                }, {
                    duration: 500,
                    complete: function () {
                        $('.p3i').eq(index_a).animate({opacity: 1}, {duration: 1000});
                        $('.p3t').eq(index_a).animate({opacity: 1}, {duration: 500});
                    }
                }, "linear");
            } else if (i < index_a) {
                $('.p3m').eq(i).animate({
                    left: centerl - (80 * p3scale) - (38 + bigw * zoomS) * (index_a - i)
                }, {
                    duration: 500
                }, "linear");
            } else {
                $('.p3m').eq(i).animate({
                    left: centerl + bigw - 80 * p3scale + (38 + bigw * zoomS) * (i - index_a)
                }, {
                    duration: 500
                }, "linear");
            }
        }
    })
    $('#btn-left-a').click(function () {
        if (playing) return;
        playing = true;
        setTimeout(function () {
            playing = false;
        }, 1000);
        var cur_index = index_a;
        index_a--;
        if (index_a < 0) return;
        var hidel = centerl + bigw - 80 * p3scale + (38 + bigw * zoomS);
        for (var i = 0; i < 5; i++) {
            if (i == cur_index) {
                $('.p3i').eq(i).animate({opacity: 0}, {duration: 500});
                $('.p3t').eq(i).animate({opacity: 0}, {duration: 500});
                $('.p3m').eq(cur_index).animate({
                    left: hidel, width: bigw * zoomS, top: smallTop
                }, 500, function () {

                });
            } else if (i == index_a) {

                $('.p3m').eq(i).animate({
                    left: centerl, width: bigw, top: centert
                }, {
                    duration: 500,
                    complete: function () {
                        $('.p3i').eq(index_a).animate({opacity: 1}, {duration: 1000});
                        $('.p3t').eq(index_a).animate({opacity: 1}, {duration: 500});
                    }
                }, "linear");
            } else if (i < index_a) {
                $('.p3m').eq(i).animate({
                    left: centerl - (80 * p3scale) - (38 + bigw * zoomS) * (index_a - i)
                }, {
                    duration: 500
                }, "linear");
            } else {
                $('.p3m').eq(i).animate({
                    left: centerl + bigw - 80 * p3scale + (38 + bigw * zoomS) * (i - index_a)
                }, {
                    duration: 500
                }, "linear");
            }
        }
    })
// var smalls = $('#small-list').clone(true);
    function setSmallImg(r) {
// 	var ary = [];
// 	var bg = index_a == 0 ? 5 : index_a;
// 	for (var i = 0; i < 5; i++) {
// 		ary.push(bg)
// 		if(bg == 5){
// 			bg = 1;
// 		}else{
// 			bg++;
// 		}
// 	};
// 	for (var i = ary.length; i > 0; i--) {
// 		$('#s'+(ary[i])).parent().prependTo($('#small-list'));
// 	};
// 	$('#small-list li').css({'margin-right':0}).show();
// 	$('#s'+(index_a+1)).parent().hide()
// 	$('#small-list li:visible').first().css({
// 		'margin-right':$('#step3').width()*0.62
// 	})
        $('.btn-bottom').css({
            top: $(window).height() - 60
        })
    }

// STEP 4
    var s4Left = W_Width * 80 / 1524;
    $('.s4-img').css({
        'left': s4Left,
        'width': W_Width - 2 * s4Left,
        'top': $('#main-item-4 .bg').height() * 10 / 888,
    })

    var index_s4 = 0;
    var s4w = $('.s4-img').width();
    var s4l = $('.s4-img').css('left');
    $('#btn-right-b').click(function () {
        if (playing) return;
        $('.p4mask').hide();
        playing = true;
        setTimeout(function () {
            playing = false;
        }, 1000);
        index_s4++
        if(index_s4 > $('.s4-img').length-1) index_s4 = 0;
        var tohide = index_s4 > 0 ? index_s4 - 1 : $('.s4-img').length - 1;
        $('.s4-img').eq(tohide).animate({
            left: -s4w,
            opacity: 0
        }, {
            duration: 1000
        }, "linear");

        $('.s4-img').eq(index_s4).css({left: $(window).width()});
        $('.s4-img').eq(index_s4).animate({
            left: s4l,
            opacity: 1
        }, {
            duration: 1000
        }, "linear");
        setSmallImg(true);
    })
    $('#btn-left-b').click(function () {
        if (playing) return;
        $('.p4mask').css({opacity: 0});
        playing = true;
        setTimeout(function () {
            playing = false;
        }, 1000);
        index_s4--;
        if(index_s4 < 0) index_s4 = $('.s4-img').length - 1;
        var tohide = index_s4 < $('.s4-img').length - 1 ? index_s4 + 1 : 0;
        $('.s4-img').eq(tohide).animate({
            left: $(window).width(),
            opacity: 0
        }, {
            duration: 1000
        }, "linear");

        $('.s4-img').eq(index_s4).css({left: -s4w});
        $('.s4-img').eq(index_s4).animate({
            left: s4l,
            opacity: 1
        }, {
            duration: 1000
        }, "linear");

        setSmallImg(false);
    })

    $('#main').fullpage({
        anchors: ['page1', 'page2', 'page3', 'page4'],
        menu: '#menu',
        verticalCentered: false,
        keyboardScrolling: true,
        scrollingSpeed: 700,

        onLeave: onLeave,
        afterLoad: function (anchorLink, index) {

            //page4
            //if(anchorLink == 'page4'){
            //	$('#main-item-4 .an').addClass('slideLeft');
            //}
        }

    });

    $('.main-item').css({
        height: $(window).height()
    })
    $('.btn-bottom').click(function () {
        var i = $('#menu li').index($('#menu li.active'));
        if (i == $('#menu li').length - 1) {
            i = 0
        } else {
            i++
        }
        // $('#menu li a').eq(i).click();
        location.hash = $('#menu li a').eq(i).attr('href');
        return false;
        // return false;
    })
    isApppend = false;
    $('#main-item-1 .play').click(function () {
        var video = document.getElementById('video');
        if (video.paused) {
            video.width = $(window).width();
            video.play();
        } else {
            video.pause();
            video.width = 0;
        }
        return;
        //页面层
        layer.open({
            type: 1,
            title: false,
            closeBtn: false,
            shadeClose: true,
            skin: 'yourclass',
            content: '<object type="application/x-shockwave-flash" align="middle" data="./video/player.swf" width="310" height="188" id="player_normal"><param name="allowfullscreen" value="true"><param name="allowscriptaccess" value="always"><param name="bgcolor" value="#000000"><param name="wmode" value="opaque"><param name="flashvars" value="image=/sun_block/video/mn.jpg&amp;movie=/sun_block/video/15s.mp4&amp;autoplay=true&amp;loop=false&amp;autohide=false&amp;fullscreen=true&amp;color_text=0xFFFFFF&amp;color_seekbar=0x13ABEC&amp;color_loadingbar=0x828282&amp;color_seekbarbg=0x333333&amp;color_button_out=0x333333&amp;color_button_over=0x000000&amp;color_button_highlight=0xffffff"></object>'
        });
    })
    $('#video').click(function () {
        var video = document.getElementById('video');
        if (video.paused) {
            video.width = $(window).width();
            video.play();
        } else {
            video.pause();
            video.width = 0;
        }
        return;
        //页面层
        layer.open({
            type: 1,
            title: false,
            closeBtn: false,
            shadeClose: true,
            skin: 'yourclass',
            content: '<object type="application/x-shockwave-flash" align="middle" data="./video/player.swf" width="310" height="188" id="player_normal"><param name="allowfullscreen" value="true"><param name="allowscriptaccess" value="always"><param name="bgcolor" value="#000000"><param name="wmode" value="opaque"><param name="flashvars" value="image=/sun_block/video/mn.jpg&amp;movie=/sun_block/video/15s.mp4&amp;autoplay=true&amp;loop=false&amp;autohide=false&amp;fullscreen=true&amp;color_text=0xFFFFFF&amp;color_seekbar=0x13ABEC&amp;color_loadingbar=0x828282&amp;color_seekbarbg=0x333333&amp;color_button_out=0x333333&amp;color_button_over=0x000000&amp;color_button_highlight=0xffffff"></object>'
        });
    })
});

