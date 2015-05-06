// Generated by CoffeeScript 1.8.0
(function() {
  var count, handleComplete, handleFileLoad, handleProgress, home_arr, init, initP1, initP3, initP5, initP6, intv, load, loveItem, manifest1, p1, p6p1, p6p2, p6try, refresh, slideChange;

  home_arr = [];

  manifest1 = [
    {
      src: "t1.jpg",
      id: "t1"
    }, {
      src: "t2.jpg",
      id: "t2"
    }, {
      src: "t3.jpg",
      id: "t3"
    }, {
      src: "t4.jpg",
      id: "t4"
    }, {
      src: "t5.jpg",
      id: "t5"
    }, {
      src: "t6.jpg",
      id: "t6"
    }, {
      src: "t7.jpg",
      id: "t7"
    }, {
      src: "t8.jpg",
      id: "t8"
    }, {
      src: "t9.jpg",
      id: "t9"
    }, {
      src: "t10.jpg",
      id: "t10"
    }, {
      src: "p2.jpg",
      id: "p2"
    }, {
      src: "p3-i1.jpg",
      id: "p3-i1"
    }, {
      src: "p3-i1.jpg",
      id: "p3-i2"
    }, {
      src: "p3-left-arrow.png",
      id: "p3-left-arrow"
    }, {
      src: "p3-right-arrow.png",
      id: "p3-right-arrow"
    }, {
      src: "p3-top.png",
      id: "p3-top"
    }, {
      src: "p3-love.png",
      id: "p3-love"
    }, {
      src: "p3-share.png",
      id: "p3-share"
    }, {
      src: "p3-btn.jpg",
      id: "p3-btn"
    }, {
      src: "p3-bottom.png",
      id: "p3-bottom"
    }, {
      src: "p4.jpg",
      id: "p4"
    }, {
      src: 'share-tip.jpg',
      id: 'share-tip'
    }, {
      src: "p5-bg.jpg",
      id: "p5-bg"
    }, {
      src: "p5-b1.png",
      id: "p5-b1"
    }, {
      src: "p5-b2.png",
      id: "p5-b2"
    }, {
      src: "p5-i1.png",
      id: "p5-i1"
    }, {
      src: "p5-i2.png",
      id: "p5-i2"
    }, {
      src: "p5-i3.png",
      id: "p5-i3"
    }, {
      src: "p5-i4.png",
      id: "p5-i4"
    }, {
      src: "p5-i5.png",
      id: "p5-i5"
    }, {
      src: "p3-left-arrow.png",
      id: "p5-left-arrow"
    }, {
      src: "p3-right-arrow.png",
      id: "p5-right-arrow"
    }, {
      src: "p6-bg2.jpg",
      id: "p6-bg2"
    }, {
      src: "p6-try.png",
      id: "p6-try"
    }, {
      src: "p6-share.png",
      id: "p6-share"
    }, {
      src: "p6-close.png",
      id: "p6-close"
    }, {
      src: "p6-tip2.jpg",
      id: "p6-tip2"
    }, {
      src: "p6-bg.jpg",
      id: "p6-bg"
    }
  ];

  count = 0;

  intv = '';

  p1 = function() {
    var top1, top2;
    top1 = (this.windowHeight - ($('#loading-img').height() + $('#loading-label').height() + 30)) / 2;
    $('#loading-img').css({
      top: top1
    });
    top2 = top1 + $('#loading-img').height() + 30;
    return $('#loading-label').css({
      top: top2
    });
  };

  refresh = function() {
    if (count > 10) {
      clearInterval(intv);
      return;
    }
    p1();
    return count++;
  };

  intv = setInterval(refresh, 500);

  init = function() {
    this.windowWidth = $(window).width();
    this.windowHeight = $(window).height();
    this.scale = this.windowWidth / 750;
    $('#fullpage').hide();
    $('#tip').hide();
    $('#tip').click(function() {
      return $('#tip').hide();
    });
    $('#tip2').hide();
    $('#tip2').click(function() {
      return $('#tip2').hide();
    });
    $('#p5-label').css({
      bottom: 62 * this.scale
    });
    return p1();
  };

  init();

  handleProgress = function(event) {
    var percent;
    percent = event.loaded;
    return $('#loading-label').text(Math.round(percent * 100) + '%');
  };

  handleComplete = function(event) {
    var animate, arr, i, s1;
    s1 = $('#section0');
    arr = s1.find('img');
    i = arr.length;
    animate = function() {
      var deg, img;
      i--;
      if (i > 0) {
        deg = 0;
        img = s1.find(arr[i]);
        return img.animate({
          deg: 180,
          opacity: 1
        }, {
          duration: 500,
          step: function(now) {
            if (now > 1) {
              return img.css({
                transform: 'rotateX(' + (180 - now) + 'deg)',
                '-webkit-transform': 'rotateX(' + (180 - now) + 'deg)'
              });
            }
          },
          complete: function() {
            return animate();
          }
        });
      }
    };
    animate();
    $('#loading-img').animate({
      opacity: 0
    }, 800);
    return $('#loading-label').animate({
      opacity: 0
    }, 800, function() {
      $('#loading-img').remove();
      $('#loading-label').remove();
      return $('#fullpage').show();
    });
  };

  initP1 = function(image, id) {
    var h, s1, w, x, y;
    image.width *= this.scale;
    image.height *= this.scale;
    w = image.width;
    h = image.height;
    x = 0;
    y = 0;
    if (id === 't2') {
      x = home_arr[0].w;
    } else if (id === 't3') {
      y = home_arr[0].h;
      x = this.windowWidth - home_arr[1].w - w;
    } else if (id === 't4') {
      y = home_arr[0].h;
    } else if (id === 't5') {
      x = home_arr[3].w;
      y = home_arr[1].h;
    } else if (id === 't6') {
      y = home_arr[3].h + home_arr[3].y;
    } else if (id === 't7') {
      x = home_arr[5].w;
      y = home_arr[5].y;
    } else if (id === 't8') {
      y = home_arr[6].y + home_arr[6].h;
    } else if (id === 't9') {
      x = home_arr[7].x + home_arr[7].w;
      y = home_arr[7].y;
    } else if (id === 't10') {
      y = this.windowHeight - h;
    }
    s1 = $('#section0');
    s1.prepend(image);
    s1.find(image).css({
      position: 'absolute',
      left: x,
      top: y,
      opacity: 0,
      deg: 180,
      'transform-origin': '50% 0% 0px',
      transform: 'rotateX(180deg)'
    });
    return home_arr.push({
      w: w,
      h: h,
      x: x,
      y: y
    });
  };

  slideChange = function(pi, si) {
    this.pi = pi;
    return this.si = si;
  };

  loveItem = function() {
    return console.log(this.pi, this.si);
  };

  initP3 = function(image, id) {
    var ltop, p3bw, p3w, s2, stop, top3;
    s2 = $('#section2');
    top3 = (this.windowHeight - 722 * this.scale) / 2;
    ltop = top3 + 722 * this.scale - 10 - 38 * this.scale;
    $('#love-label').css({
      left: 70 * this.scale,
      top: ltop + 5
    });
    if (id.indexOf('p3-i') !== -1) {
      $('#' + id).prepend(image);
      $('#' + id).find(image).css({
        width: 750 * this.scale,
        top: top3,
        position: 'absolute',
        'z-index': 100
      });
    } else {
      s2.append(image);
    }
    if (id === 'p3-left-arrow') {
      return s2.find(image).css({
        width: 28 * this.scale,
        left: 10,
        top: (this.windowHeight - image.height) / 2,
        position: 'absolute',
        'z-index': 100
      });
    } else if (id === 'p3-right-arrow') {
      return s2.find(image).css({
        width: 28 * this.scale,
        right: 10,
        top: (this.windowHeight - image.height) / 2,
        position: 'absolute',
        'z-index': 100
      });
    } else if (id === 'p3-top') {
      return s2.find(image).css({
        width: 432 * this.scale,
        top: 90 * this.scale,
        left: 178 * this.scale,
        position: 'absolute',
        'z-index': 100
      });
    } else if (id === 'p3-love') {
      ltop = top3 + 722 * this.scale - 10 - 38 * this.scale;
      s2.find(image).css({
        width: 43 * this.scale,
        left: 23 * this.scale,
        top: ltop,
        position: 'absolute',
        'z-index': 100
      });
      return s2.find(image).click(loveItem);
    } else if (id === 'p3-share') {
      stop = top3 + 722 * this.scale - 10 - 76 * this.scale;
      s2.find(image).css({
        width: 54 * this.scale,
        right: 23 * this.scale,
        top: stop,
        position: 'absolute',
        'z-index': 100
      });
      return s2.find(image).click(function() {
        return $('#tip').show();
      });
    } else if (id === 'p3-btn') {
      p3w = 316 * this.scale;
      return s2.find(image).css({
        top: 722 * this.scale + top3 - 8,
        width: p3w,
        left: (this.windowWidth - p3w) / 2,
        position: 'absolute'
      });
    } else if (id === 'p3-bottom') {
      p3bw = 175 * this.scale;
      return s2.find(image).css({
        bottom: 75 * this.scale,
        width: p3bw,
        left: (this.windowWidth - p3bw) / 2,
        position: 'absolute',
        'z-index': 100
      });
    }
  };

  initP5 = function(image, id) {
    var btnbottom, it, s4;
    s4 = $('#section4');
    if (id.indexOf('p5-i') === -1) {
      s4.append(image);
    } else {
      $('#' + id).prepend(image);
      it = this.windowHeight < 500 ? 160 * this.scale : 240 * this.scale;
      $('#' + id).find(image).css({
        width: 602 * this.scale,
        left: 83 * this.scale,
        top: it,
        position: 'relative'
      });
    }
    btnbottom = this.windowHeight < 530 ? 80 * this.scale : 120 * this.scale;
    if (id === 'p5-bg') {
      image.width = $(window).width();
      return s4.find(image).css({
        top: 0,
        position: 'absolute'
      });
    } else if (id === 'p5-left-arrow') {
      return s4.find(image).css({
        width: 28 * this.scale,
        left: 10,
        top: (this.windowHeight - image.height) / 2,
        position: 'absolute',
        'z-index': 100
      });
    } else if (id === 'p5-right-arrow') {
      return s4.find(image).css({
        width: 28 * this.scale,
        right: 10,
        top: (this.windowHeight - image.height) / 2,
        position: 'absolute',
        'z-index': 100
      });
    } else if (id === 'p5-b1') {
      return s4.find(image).css({
        width: 291 * this.scale,
        left: 57 * this.scale,
        bottom: btnbottom,
        position: 'absolute'
      });
    } else if (id === 'p5-b2') {
      return s4.find(image).css({
        width: 291 * this.scale,
        right: 57 * this.scale,
        bottom: btnbottom,
        position: 'absolute'
      });
    }
  };

  p6p1 = '';

  p6p2 = '';

  p6try = '';

  initP6 = function(image, id) {
    var css, s5;
    s5 = $('#section5');
    if (id === 'p6-bg') {
      s5.prepend(image);
      image.width = $(window).width();
      p6p1 = s5.find(image);
      p6p1.addClass('p6p1');
      p6p1.on('click touchstart', function() {
        console.log('11');
        p6p1.hide();
        return $('.p6p2').show();
      });
      return p6p1.css({
        top: 0,
        position: 'absolute'
      });
    } else if (id === 'p6-bg2') {
      s5.prepend(image);
      image.width = $(window).width();
      p6p2 = s5.find(image);
      p6p2.hide();
      p6p2.addClass('p6p2');
      return p6p2.css({
        top: 0,
        position: 'absolute',
        display: 'none'
      });
    } else if (id === 'p6-try') {
      s5.append(image);
      s5.find(image).addClass('p6p2');
      p6try = s5.find(image);
      s5.find(image).on('click touchstart', function() {
        p6p1.show();
        return $('.p6p2').hide();
      });
      return s5.find(image).css({
        bottom: 400 * this.scale,
        width: this.windowWidth / 2,
        left: this.windowWidth / 4,
        position: 'absolute',
        display: 'none'
      });
    } else if (id === 'p6-share') {
      s5.append(image);
      s5.find(image).addClass('p6p2');
      s5.find(image).click(function() {
        return $('#tip2').show();
      });
      return s5.find(image).css({
        bottom: 292 * this.scale,
        width: this.windowWidth / 2,
        left: this.windowWidth / 4,
        position: 'absolute',
        display: 'none'
      });
    } else if (id === 'p6-close') {
      s5.append(image);
      css = {
        width: 74 * this.scale,
        height: 74 * this.scale,
        top: 20 * this.scale,
        right: 20 * this.scale,
        position: 'absolute'
      };
      s5.find(image).css(css);
      return s5.find(image).on('click touchstart', function() {
        console.log('close');
        return wx.closeWindow();
      });
    } else if (id === 'p6-tip2') {
      image.width = $(window).width();
      return $('#tip2').append(image);
    }
  };

  handleFileLoad = function(event) {
    var image, item, s1, s3;
    image = event.result;
    item = event.item;
    if (item.id.indexOf('p3') !== -1) {
      return initP3(image, item.id);
    } else if (item.id === 'p2') {
      s1 = $('#section1');
      image.width = $(window).width();
      return s1.prepend(image);
    } else if (item.id === 'p4') {
      s3 = $('#section3');
      image.width = $(window).width();
      return s3.prepend(image);
    } else if (item.id === 'share-tip') {
      image.width = $(window).width();
      return $('#tip').prepend(image);
    } else if (item.id.indexOf('p5') !== -1) {
      return initP5(image, item.id);
    } else if (item.id.indexOf('p6') !== -1) {
      return initP6(image, item.id);
    } else if (item.id.indexOf('t') !== -1) {
      return initP1(image, item.id);
    }
  };

  load = function() {
    var preload;
    preload = new createjs.LoadQueue();
    preload.on("progress", handleProgress);
    preload.on("complete", handleComplete);
    preload.on("fileload", handleFileLoad);
    return preload.loadManifest(manifest1, true, 'imgs/home/');
  };

  load();

}).call(this);
