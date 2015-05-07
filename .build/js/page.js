manifest1 = [
    {src: "t1.jpg", id: "t1"}
];


$(document).ready(function () {
    W_Width = $(window).width();
    W_Height = $(window).height();
    var ratio = W_Width / W_Height;
    var step3_width = W_Width * 600 / 1524;
    var playing = false;

//第二页
    var p1default = $('#i0');
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
    var loveNum = 0;
    var setLoveNum = function () {
        loveNum= Math.round(Math.random() * 100);
        $('#loveNum').text('x' + loveNum);
    };
    setLoveNum();
    $('.love').click(function () {
        loveNum++;
        $('#loveNum').text('x'+loveNum);
    });

    sharep2 = function(){
        var sl = p1default.selector;
        sl = sl.replace('#', '');
        var txt = '';
        var arr = [
            '以为墨镜够高冷，挡得住眼挡不住脸！玩转潮流有逼格，#青春就要大胆晒#',
            '举片树叶遮太阳，这是野人新风尚？亲近自然爱阳光，#青春就要大胆晒#',
            '帅气多金不敢露，头戴草帽装路人！谁说土豪要低调？#青春就要大胆晒#',
            '满嘴术语没人懂，高端装备脑洞开太大。天赋异禀难自弃，#青春就要大胆晒#',
            '头巾包的只剩眼，人群里看N百遍也认不出！一见钟情不是梦，#青春就要大胆晒#',
            '脸基尼是什么鬼？又不是飞檐走壁的蜘蛛侠！太阳底下任我行，#青春就要大胆晒#',
            'Dota打怪不积极，出个门又何必武装至此！轻装出行无压力，#青春就要大胆晒#',
            '顶个畚箕当阳伞，难怪永远单身狗！要想男神女神爱，#青春就要大胆晒#'
        ]
        txt = arr[parseInt(sl.replace('i', ''))-1];
        openwin('http://proyaproject.duapp.com/w/images/' + sl+'.jpg', txt);
        console.log(sl);
    }

    var width_step2 = W_Width/W_Height > 2 ? W_Height*1524/736 : W_Width;
    var height_step2 = width_step2*736/1524;
    $('#main-item-2 table').css({
        'margin-left': (W_Width-width_step2)/2,
        'width':width_step2
    })
    $('.nw1 div').width(width_step2 * 566 / 1524)//.find('img').width(width_step2 * 566 / 1524);
    $('.nw2 div').width(width_step2 * 278 / 1524);
    $('.nw3 div').width(width_step2 * 258 / 1524);
    $('.nw4').width(width_step2 * 260 / 1524);
    $('.nw5').width(width_step2 * 308 / 1524);
    $('.nw6 div').width(width_step2 * 584 / 1524);
    $('#img-main div').width(width_step2 * 680 / 1524);

    nh1 = height_step2 * 196 / 730;
    nh2 = height_step2 * 370 / 730;
    nh3 = nh2 - nh1;

    nh4 = height_step2 * 360 / 730;
    nh5 = height_step2 * 179 / 730;
    nh6 = nh4 - nh5;
    $('.nh1 div').height(nh1)//.find('img').height(nh1);
    $('.nh2 div').height(nh2)//.find('img').height(nh2);
    $('.nh3 div').height(nh3)//.find('img').height(nh3);
    $('.nh4 div').height(nh4)//.find('img').height(nh4);
    $('.nh5 div').height(nh5)//.find('img').height(nh5);
    $('.nh6 div').height(nh6)//.find('img').height(nh6);

    function setTableHeight() {
//        $('.w1').width(W_Width * 567 / 1524);
//        $('.w2').width(W_Width * 278 / 1524);
//        $('.w3').width(W_Width * 259 / 1524);
//        $('.w4').width(W_Width * 308 / 1524);
//        $('.w5').width(W_Width * 585 / 1524);
//        $('.wb1').width(W_Width * 679 / 1524);

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
            $(this).closest('td').css({
                height: $(this).height()
            });
            // $(this).css({
            //     // width: $(this).closest('td').width(),
            //     height: $(this).closest('td').height()
            // });

        });
        $('.front .img-i').click(function () {
            if(playing) return;
            playing = true;
            setTimeout(function () {
                playing = false
            }, 500);
            var arr = ['#i3', '#i4', '#i7', '#i8'];
            var id = $(this).attr('data-target');
            // console.log('ccc');
            setLoveNum();
            $('.love').show();
            $('.btn-share').show();
            $('.loveNum').show();
//            p1default.fadeOut();
//            $(id).fadeIn();
            p1default.animate({opacity: 0}, {
                duration: 300,complete:function(){
                    $(id).animate({opacity: 1}, 500);
                }
            });
            p1default = $(id);
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

    var updateTable = function(){
        //var width_step2 = W_Width/W_Height > 2 ? W_Height*2 : W_Width;
        //$('.w1').width(width_step2 * 567 / 1524);
        //$('.w2').width(width_step2 * 277 / 1524);
        //$('.w3').width(width_step2 * 259 / 1524);
        //$('.w4').width(width_step2 * 308 / 1524);
        //$('.w5').width(width_step2 * 585 / 1524);
        //$('.wb1').width(width_step2 * 679 / 1524);
        //
        //$('#main-item-2 table').css({
        //    'margin-left': (W_Width - width_step2) / 2,
        //    'width': width_step2
        //});
        //console.log(W_Width / W_Height, W_Height)
        //if(W_Width / W_Height > 2 || W_Height < 560){
        //    $('#s2table').css({width: 700});
        //    console.log($('#s2table').width());
        //}else{
        //    $('#s2table').css({width: W_Width});
        //}
    }

    $(window).scroll(function () {
        setTableHeight();
    });
    var si2 = setInterval(function () {
        if($('.bg3').height()<W_Height){
            $('.bg3').css({height: W_Height});
        }
        setTableHeight();
        updateTable();
        positionTitle();
    }, 1000)
// setTableHeight();

    updateTable();

    var index_a = 2;
    var p3scale = W_Height / 892;
    var bigw = 251 * p3scale;
    var bigh = 549 * p3scale;
    var p3bgw = 1846 * p3scale;
    var centerl = (step3_width - bigw) / 2;
    var centert = W_Height - 88 * p3scale - bigh;
    var zoomS = 0.38;
    var smallTop = centert + 0.91 * bigh - bigh * zoomS;
    var preleft = 0;

    var changeBG = function (old) {
        if (old) {
            $('#p3b' + old).hide();
        }
        $('#p3b' + index_a).show();
    };

    var initP3 = function () {
        $('.family').css({left:centerl-350,top:centert-100});
        //$('.bg3').css({height: W_Height});
        for (var i = 0; i < 5; i++) {
            preleft = 0;
            if (i < index_a) {
                preleft = centerl - (80 * p3scale) - (38 + bigw * zoomS) * (index_a - i)
                $('.p3m').eq(i).css({width: bigw * zoomS, top: smallTop, left: preleft});
            } else if (i > index_a) {
                preleft = centerl + bigw - 80 * p3scale + (38 + bigw * zoomS) * (i - index_a);
                $('.p3m').eq(i).css({width: bigw * zoomS, top: smallTop, left: preleft});
            } else if (i == index_a) {
                $('.p3m').eq(index_a).css({opacity: 0, width: bigw, left: centerl, top: centert});
                $('.p3t').eq(index_a).css({left: (step3_width - 467) / 2});
            }
        }

    };

    var positionTitle = function(){
        for (var i = 0; i < 5; i++) {
            var o = $('.p3t').eq(i);
            o.css({left: (step3_width - o.width()) / 2});
        }
    }

    initP3();
    changeBG();

    var onLeave = function (index, nextIndex) {
        if (nextIndex == 3) {
            $('.p3t').eq(index_a).css({opacity: 0});
            $('.p3m').css({opacity: 0});
            $('.family').css({opacity: 0});
            $('#btn-left-a').css({opacity: 0});
            $('#btn-right-a').css({opacity: 0});
            $('.ticket').css({opacity: 0});
            setTimeout(function () {

            $('.p3m').animate({opacity: 1}, {
                duration: 1000, complete: function () {
                    console.log('oo2')
                    $('.p3t').eq(index_a).animate({opacity: 1}, {
                        duration: 500, complete: function () {
                            $('#btn-left-a').animate({opacity: 1}, {duration: 1000});
                            $('#btn-right-a').animate({opacity: 1}, {duration: 1000});
                            $('.family').animate({opacity: 1}, {duration: 1000});
                            $('.ticket').animate({opacity: 1}, {duration: 1000});
                        }
                    })
                }
            });
            }, 1000);
        } else if (nextIndex == 4) {
            $('#p4mask').css({opacity: 1});
            $('#p40').animate({opacity: 0}, {
                duration: 2000, complete: function () {
                $('#p41').animate({opacity: 0}, {
                    duration: 300, complete: function () {
                        $('#p42').animate({opacity: 0}, {
                            duration: 300, complete: function () {
                                $('#p43').animate({opacity: 0}, {
                                    duration: 300, complete: function () {
                                        $('#p44').animate({opacity: 0}, {
                                            duration: 300, complete: function () {
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
                })
            }});
        }
    };

    var order = [0, 1, 2, 3, 4];
    var updateP3 = function (cur_index, left) {
        changeBG(cur_index);
        var temp = order.concat();
        var j = 0;
        if(!left){
            for(var i=0; i<5; i++){
                j = i > 0 ? i - 1 : 4;
                temp[j] = order[i];
            }
        }else{
            for(var i=0; i<5; i++){
                j = i < 4 ? i + 1 : 0;
                temp[j] = order[i];
            }
        }
        order = temp;

        var hidel = left ? centerl + bigw - 80 * p3scale + (38 + bigw * zoomS) : centerl - (80 * p3scale) - bigw * zoomS;
        var tohide = !left ? order[1] : order[3];

        $('.p3t').eq(tohide).animate({opacity: 0}, {duration: 500});
        $('.p3m').eq(tohide).animate({
            left: hidel, width: bigw * zoomS, top: smallTop
        }, {
            duration: 500
        });

        $('.p3m').eq(order[2]).animate({
            left: centerl, width: bigw, top: centert
        }, {
            duration: 500,
            complete: function () {
                $('.p3t').eq(order[2]).animate({opacity: 1}, {duration: 500});
            }
        }, "linear");

        if(left){
            $('.p3m').eq(order[4]).animate({
                left: centerl + bigw - 80 * p3scale + (38 + bigw * zoomS) * 2
            }, {
                duration: 500
            }, "linear");

            $('.p3m').eq(order[0]).css({left: centerl - (80 * p3scale) - (38 + bigw * zoomS) * 2});
            $('.p3m').eq(order[1]).animate({
                left: centerl - (80 * p3scale) - (38 + bigw * zoomS)
            }, {
                duration: 500
            }, "linear");
        }else {
            $('.p3m').eq(order[0]).animate({
                left: centerl - (80 * p3scale) - (38 + bigw * zoomS) * 2
            }, {
                duration: 500
            }, "linear");
            $('.p3m').eq(order[4]).css({left: centerl + bigw - 80 * p3scale + (38 + bigw * zoomS) * 2});
            $('.p3m').eq(order[3]).animate({
                left: centerl + bigw - 80 * p3scale + (38 + bigw * zoomS) * 1
            }, {
                duration: 500
            }, "linear");
        }

    };


    $('#btn-right-a').click(function () {
        if (playing) return;
        playing = true;
        setTimeout(function () {
            playing = false;
        }, 1000);
        var cur_index = index_a;
        index_a++;
        if (index_a > 4) index_a = 0;
        updateP3(cur_index);
    })
    $('#btn-left-a').click(function () {
        if (playing) return;
        playing = true;
        setTimeout(function () {
            playing = false;
        }, 1000);
        var cur_index = index_a;
        index_a--;
        if (index_a < 0) index_a = 4;
        updateP3(cur_index, true);
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
            top: $(window).height() - 40
        })
    }

// STEP 4
    var cr = 1524/888;
    var s4Left = W_Width * 80 / 1524;
    var s4w = (W_Height) * cr;
    var s4scale = s4w/1524;

    if(s4w/cr < W_Height){
        s4Left = (W_Width/2 - s4w/2);
    }else{
        s4Left = (W_Width/2 - s4w/2);
    }
    var s4top = (W_Height-(s4w-80)/cr)/2;
    $('.s4-img').css({
        'left': s4Left,
        'width': s4w-80,
        'top': s4top
    });

    var index_s4 = 0;
    var s4l = s4Left;
    var s4scale = s4w / 1524;
    var s4t = $('.s4-img').css('top');
    //$('#p40').css({width: 888 * s4scale, height: 420 * s4scale, left: 340 * s4scale+s4Left, top: 20 * s4scale});
    //$('#p41').css({width: 289 * s4scale, height: 355 * s4scale, left: 100 * s4scale+s4Left, top: 60 * s4scale});
    //$('#p42').css({width: 273 * s4scale, height: 400 * s4scale, left: 110 * s4scale+s4Left, top: 400 * s4scale});
    //$('#p43').css({width: 295 * s4scale, height: 385 * s4scale, left: 390 * s4scale+s4Left, top: 320 * s4scale});
    //$('#p44').css({width: 373 * s4scale, height: 304 * s4scale, left: 720 * s4scale+s4Left, top: 435 * s4scale});
    //$('#p45').css({width: 295 * s4scale, height: 455 * s4scale, right: 90 * s4scale+s4Left, top: 240 * s4scale});

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
        $('.s4-img').eq(index_s4).show();
        if(index_s4 > $('.s4-img').length-1) index_s4 = 0;
        var tohide = index_s4 > 0 ? index_s4 - 1 : $('.s4-img').length - 1;
        $('.s4-img').eq(tohide).animate({
            left: -s4w
        }, 1000,'easeInOutBack');

        $('.s4-img').eq(index_s4).css({left: $(window).width()});
        $('.s4-img').eq(index_s4).animate({
            left: s4l
        }, 1000,'easeInOutBack');
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
            left: $(window).width()
        },
            1000
        , "easeInOutBack");

        $('.s4-img').eq(index_s4).show();
        $('.s4-img').eq(index_s4).css({left: -s4w});
        $('.s4-img').eq(index_s4).animate({
            left: s4l
        }, 1000
        , "easeInOutBack");

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
        $('#video').show();
        if (video.paused) {
            video.width = $(window).width();
            video.height = $(window).height();
            //console.log($("#video").innerWidth());
            //$('#video').css({left:($(window).width()-$("#video").innerWidth())/2});
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

