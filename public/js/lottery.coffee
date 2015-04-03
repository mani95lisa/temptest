Base =
  init : ->
    this.windowWidth = $(window).width();
    this.windowHeight = $(window).height();
    this.scale = this.windowWidth/640;

    #定位按钮遮罩
    Base.position($('#button_mask'),242,251,199,592)
    $('#button_mask').click ->
      if count_down_time <= 0
        _hmt.push(['_trackEvent', '大白活动1', '查看抽奖']);
        window.location = draw_url
      else
        _hmt.push(['_trackEvent', '大白活动1', '直接抽奖']);
        window.location = draw_url

    #定位参与人数
    Base.position($('#joined'),this.windowWidth/this.scale,40,0,440)
    $('#joined').css('text-align':'center')

    #定位倒计时
    Base.position($('#count_down'),516,84,60,488)
    $('#time_bg').css(width:'100%',position:'absolute')
    $('#time_lines').css(width:429*this.scale,left:52*this.scale,top:82*this.scale/2,position:'absolute')
    num_w = 31*this.scale
    num_h = 61*this.scale
    i = 0
    left = 50*this.scale
    top = 35*this.scale/2
    gap1 = 34*this.scale
    gap2 = 73.5*this.scale
    while i< 8
      if i%2 == 0
        left += 9*this.scale
        if i
          left += gap2
      else
        left += gap1
      i++
      $('#num'+i).css(position:'absolute',width:num_w,left:left,top:top)

    setNumValue = (index, value)->
      $('#num'+index).attr('src', 'imgs/'+value+'.png')

    setTwoValue = (i1, i2, value)->
      if value < 10
        setNumValue i1, 0
        setNumValue i2, value
      else
        value = value+''
        setNumValue i1,value.slice(0,1)
        setNumValue i2,value.slice(1,2)

    interval = setInterval ->
      count_down_time-=1000
      if count_down_time > 0
        day = Math.floor(count_down_time / (24*60*60*1000))
        setTwoValue 1, 2, day
        hours = Math.floor(count_down_time % (24*60*60*1000) / (60*60*1000))
        setTwoValue 3, 4, hours
        minutes = Math.floor(count_down_time % (60*60*1000) / (60*1000))
        setTwoValue 5, 6, minutes
        seconds = Math.floor(count_down_time % (60*1000)/1000)
        setTwoValue 7, 8, seconds
      else
        clearInterval interval
        $('#button_mask').css('background','url(../imgs/lottery_btn.png) no-repeat')
        alert('活动已结束，请关注润石创投服务号参与下次活动，感谢您的支持')
    , 1000

    #定位需知和规则
    Base.position($('#need_know'),112,28,60,871)
    Base.position($('#rule'),112,28,468,871)
    Base.switchNeedKnowAndRule(true)
    $('#need_know').click ->
      Base.switchNeedKnowAndRule(true)
    $('#rule').click ->
      Base.switchNeedKnowAndRule(false)

  switchNeedKnowAndRule : (needknow)->
    if needknow
      Base.position($('#red_line'),112,1,61.5,906.5)
      $('#need_know').css(opacity:1)
      $('#rule').css(opacity:.5)
      $('#need_know_detail').show()
      $('#rule_detail').hide()
      Base.position($('#need_know_detail'),640,650,0,939)
    else
      $('#need_know').css(opacity:.5)
      $('#rule').css(opacity:1)
      $('#need_know_detail').hide()
      $('#rule_detail').show()
      Base.position($('#red_line'),112,1,469.5,906.5)
      Base.position($('#rule_detail'),640,900,0,939)

  position : (item,width,height,x,y)->
    item.css(position:'absolute',width:width*this.scale,height:height*this.scale,top:y*this.scale,left:x*this.scale)

Base.init()