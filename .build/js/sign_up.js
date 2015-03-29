// Generated by CoffeeScript 1.8.0
(function() {
  var Base;

  Base = {
    init: function() {
      var countdown, interval, registing, sentCode, switchCodeBtnStatus;
      this.windowWidth = $(window).width();
      this.windowHeight = $(window).height();
      this.scale = this.windowWidth / 640;
      Base.position($('#form'), 520, 469, 56, 200);
      $('.field').css({
        width: 520 * this.scale,
        height: 100 * this.scale
      });
      $('.field input').css({
        width: (520 - 80) * this.scale,
        height: 100 * this.scale,
        'padding-left': 40 * this.scale
      });
      $('.verify_btn').css({
        width: 180 * this.scale,
        height: 100 * this.scale
      });
      Base.position($('.verify_btn'), 180, 100, 396, $('#code_field').offset().top / this.scale);
      $('.verify_text').css({
        height: 100 * this.scale,
        'line-height': 100 * this.scale + 'px',
        padding: 0
      });
      sentCode = false;
      interval = '';
      countdown = 60;
      switchCodeBtnStatus = function() {
        if (sentCode) {
          $('.verify_btn').css({
            background: '#cccccc'
          });
          $('.verify_text').text('重发(' + countdown + ')');
          return interval = setInterval(function() {
            if (countdown <= 0) {
              clearInterval(interval);
              sentCode = false;
              countdown = 60;
              return switchCodeBtnStatus();
            } else {
              $('.verify_text').text('重发(' + countdown + ')');
              return countdown--;
            }
          }, 1000);
        } else {
          $('.verify_btn').css({
            background: '#F1B424'
          });
          return $('.verify_text').text('获取验证码');
        }
      };
      $('.verify_btn').click(function() {
        var data;
        if (!sentCode) {
          sentCode = true;
          switchCodeBtnStatus();
          data = {
            mobile: $('#mobileNum').val(),
            _csrf: $('#csrf').val()
          };
          return $.post('/verify_code', data, function(result) {
            if (result.err) {
              alert(result.err);
              sentCode = false;
              countdown = 0;
              return switchCodeBtnStatus();
            }
          });
        }
      });
      $('#submit_btn').css({
        width: 520 * this.scale,
        height: 100 * this.scale
      });
      registing = false;
      return $('#submit_btn').click(function() {
        var data, o;
        if (registing) {

        } else {
          registing = true;
          data = $('#form').serializeArray();
          o = {};
          data.forEach(function(d) {
            return o[d.name] = d.value;
          });
          return $.post('/do_sign_up', o, function(result) {
            if (result.err) {
              registing = false;
              return alert(result.err);
            } else {
              return window.location = '/draw_lottery';
            }
          });
        }
      });
    },
    position: function(item, width, height, x, y) {
      return item.css({
        position: 'absolute',
        width: width * this.scale,
        height: height * this.scale,
        top: y * this.scale,
        left: x * this.scale
      });
    }
  };

  $(document).ready(function() {
    return Base.init();
  });

}).call(this);
