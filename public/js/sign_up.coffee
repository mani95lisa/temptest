Base =
  init : ->
    this.windowWidth = $(window).width();
    this.windowHeight = $(window).height();
    this.scale = this.windowWidth/640;

    Base.position($('#form'),520,469,56,200)
    $('.field').css(width:520*this.scale,height:100*this.scale)
    $('.field input').css(width:(520-80)*this.scale,height:100*this.scale,'padding-left':40*this.scale)
    $('.verify_btn').css(width:180*this.scale,height:100*this.scale)
    Base.position($('.verify_btn'), 180, 100, 396,$('#code_field').offset().top/this.scale)
    $('.verify_text').css(height:100*this.scale,'line-height':100*this.scale+'px',padding:0)

    sentCode = false
    interval = ''
    countdown = 60
    switchCodeBtnStatus = ->
      if sentCode
        $('.verify_btn').css(background:'#cccccc')
        $('.verify_text').text('重发('+countdown+')')
        interval = setInterval ->
          if countdown <= 0
            clearInterval interval
            sentCode = false
            countdown = 60
            switchCodeBtnStatus()
          else
            $('.verify_text').text('重发('+countdown+')')
            countdown--
        ,
          1000
      else
        $('.verify_btn').css(background:'#F1B424')
        $('.verify_text').text('获取验证码')

    $('.verify_btn').click ->
      if !sentCode
        sentCode = true
        switchCodeBtnStatus()
        data = mobile:$('#mobileNum').val(),_csrf:$('#csrf').val()
        $.post '/verify_code', data, (result)->
          if result.err
            alert(result.err)
            sentCode = false
            countdown = 0
            switchCodeBtnStatus()

    $('.submit_btn').css(width:520*this.scale,height:100*this.scale)
    $('.submit_btn').click ->
      data = $('#form').serializeArray()
      o = {}
      data.forEach (d)->
        o[d.name] = d.value
      $.post '/do_sign_up', o, (result)->
        if result.err
          alert(result.err)

  position : (item,width,height,x,y)->
    item.css(position:'absolute',width:width*this.scale,height:height*this.scale,top:y*this.scale,left:x*this.scale)

$(document).ready ->
  Base.init()