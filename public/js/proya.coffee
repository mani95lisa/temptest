home_arr = []
manifest1 = [
  {src: "t1.jpg", id: "t1"},
  {src: "t2.jpg", id: "t2"},
  {src: "t3.jpg", id: "t3"},
  {src: "t4.jpg", id: "t4"},
  {src: "t5.jpg", id: "t5"},
  {src: "t6.jpg", id: "t6"},
  {src: "t7.jpg", id: "t7"},
  {src: "t8.jpg", id: "t8"},
  {src: "t9.jpg", id: "t9"},
  {src: "t10.jpg", id: "t10"}
  {src: "p2-bg.jpg", id: "p2-bg"}
  {src: "p2-video.jpg", id: "p2-video"}
  {src: "p3-i1.jpg", id: "p3-i1"}
  {src: "p3-i1.jpg", id: "p3-i2"}
  {src: "p3-left-arrow.png", id: "p3-left-arrow"}
  {src: "p3-right-arrow.png", id: "p3-right-arrow"}
  {src: "p3-top.png", id: "p3-top"}
  {src: "p3-love.png", id: "p3-love"}
  {src: "p3-share.png", id: "p3-share"}
  {src: "p3-btn.jpg", id: "p3-btn"}
  {src: "p3-bottom.png", id: "p3-bottom"}
  {src: "p4.jpg", id: "p4"}
  {src: 'share-tip.jpg', id:'share-tip'}
  {src: "p5-bg.jpg", id: "p5-bg"}
  {src: "p5-b1.png", id: "p5-b1"}
  {src: "p5-b2.png", id: "p5-b2"}
  {src: "p5-i1.png", id: "p5-i1"}
  {src: "p5-i2.png", id: "p5-i2"}
  {src: "p5-i3.png", id: "p5-i3"}
  {src: "p5-i4.png", id: "p5-i4"}
  {src: "p5-i5.png", id: "p5-i5"}
  {src: "p3-left-arrow.png", id: "p5-left-arrow"}
  {src: "p3-right-arrow.png", id: "p5-right-arrow"}
  {src: "p6-bg2.jpg", id: "p6-bg2"}
  {src: "p6-try.png", id: "p6-try"}
  {src: "p6-share.png", id: "p6-share"}
  {src: "p6-close.png", id: "p6-close"}
  {src: "p6-tip2.jpg", id: "p6-tip2"}
  {src: "p6-bg.jpg", id: "p6-bg"}
]

count = 0
intv = ''

p1 = ->
  top1 = (this.windowHeight-($('#loading-img').height()+$('#loading-label').height()+30))/2
  $('#loading-img').css(top:top1)
  top2 = top1+$('#loading-img').height()+30
  $('#loading-label').css(top:top2)

refresh = ->
  if count > 10
    clearInterval intv
    return
  p1()
  count++

intv = setInterval refresh, 500

init = ->
  this.windowWidth = $(window).width()
  this.windowHeight = $(window).height()
  this.scale = this.windowWidth/750
  $('#fullpage').hide()
  $('#tip').hide()
  $('#tip').click ->
    $('#tip').hide()
  $('#tip2').hide()
  $('#tip2').click ->
    $('#tip2').hide()
  $('#p5-label').css bottom:62*this.scale
  p1()

init()

handleProgress = (event)->
  percent = event.loaded
  $('#loading-label').text(Math.round(percent*100)+'%')
handleComplete = (event)->
  s1 = $('#section0')
  arr = s1.find('img');
#  arr.animate {deg:180,opacity:1}, duration:1500, step:(now)->
#    if now > 1
#      arr.css transform: 'rotateX(' + (180-now) + 'deg)', '-webkit-transform':'rotateX(' + (180-now) + 'deg)'
  i = arr.length
  animate = ->
    i--
    if i >= 0
      deg = 0
      img = s1.find(arr[i])
      img.animate {deg:90,opacity:1}, duration:300, step:(now)->
        if now > 1
          img.css transform: 'rotateY(' + (90-now) + 'deg)','-webkit-transform':'rotateY(' + (90-now) + 'deg)'
      , complete:->
          animate()
  animate()
  $('#loading-img').animate opacity:0, 800
  $('#loading-label').animate opacity:0, 800, ->
    $('#loading-img').remove()
    $('#loading-label').remove()
    $('#fullpage').show()
#  setTimeout ->
#    $.fn.fullpage.moveTo(6,1);
#  , 1000

initP1 = (image, id)->
  image.width *= this.scale
  image.height *= this.scale
  w = image.width
  h = image.height
  x = 0
  y = 0
  if id == 't2'
    x = home_arr[0].w
  else if id == 't3'
    y = home_arr[0].h
    x = this.windowWidth - home_arr[1].w-w
  else if id == 't4'
    y = home_arr[0].h
  else if id == 't5'
    x = home_arr[3].w
    y = home_arr[1].h
  else if id == 't6'
    y = home_arr[3].h+home_arr[3].y
  else if id == 't7'
    x = home_arr[5].w
    y = home_arr[5].y
  else if id == 't8'
    y = home_arr[6].y+home_arr[6].h
  else if id == 't9'
    x = home_arr[7].x+home_arr[7].w
    y = home_arr[7].y
  else if id == 't10'
    y = this.windowHeight - h

  s1 = $('#section0')
  s1.prepend image
  s1.find(image).css position:'absolute',left:x,top:y,opacity:0,deg:180,transform: 'rotateY(90deg)'
  home_arr.push w:w,h:h,x:x,y:y

slideChange = (pi, si)->
  this.pi = pi
  this.si = si

loveItem = ->
  console.log this.pi, this.si

initP3 = (image, id)->

  s2 = $('#section2')
  top3 = (this.windowHeight-722*this.scale)/2
  ltop = top3+722*this.scale-10 - 38*this.scale
  $('#love-label').css left:70*this.scale,top:ltop+5
  if id.indexOf('p3-i') != -1
    $('#'+id).prepend image
    $('#'+id).find(image).css width:750*this.scale,top:top3,position:'absolute', 'z-index':100
  else
    s2.append image
  if id == 'p3-left-arrow'
    s2.find(image).css width:28*this.scale,left:10,top:(this.windowHeight-image.height)/2, position: 'absolute','z-index': 100
  else if id == 'p3-right-arrow'
    s2.find(image).css width:28*this.scale,right:10,top:(this.windowHeight-image.height)/2, position: 'absolute','z-index': 100
  else if id == 'p3-top'
    s2.find(image).css width:432*this.scale,top:90*this.scale,left:178*this.scale,position:'absolute', 'z-index':100
  else if id == 'p3-love'
    ltop = top3+722*this.scale-10 - 38*this.scale
    s2.find(image).css width:43*this.scale,left:23*this.scale,top:ltop, position: 'absolute','z-index': 100
    s2.find(image).click loveItem
  else if id == 'p3-share'
    stop = top3+722*this.scale-10-76*this.scale
    s2.find(image).css width:54*this.scale,right:23*this.scale,top:stop, position: 'absolute','z-index': 100
    s2.find(image).click ->
      $('#tip').show()
  else if id == 'p3-btn'
    p3w = 316*this.scale
    s2.find(image).css top:(722*this.scale+top3-8),width:p3w,left:(this.windowWidth-p3w)/2,position:'absolute'
  else if id == 'p3-bottom'
    p3bw = 175*this.scale
    s2.find(image).css bottom:75*this.scale,width:p3bw,left:(this.windowWidth-p3bw)/2,position:'absolute', 'z-index':100

initP5 = (image, id)->
  s4 = $('#section4')
  if id.indexOf('p5-i') == -1
    s4.append image
  else
    $('#'+id).prepend image
    it = if this.windowHeight < 550 then 160*this.scale else 240*this.scale
    $('#'+id).find(image).css width:602*this.scale,left:83*this.scale,top:it,position:'relative'
  btnbottom = if this.windowHeight < 550 then 80*this.scale else 120*this.scale
  if id == 'p5-bg'
    image.width = $(window).width()
    s4.find(image).css top:0,position:'absolute'
  else if id == 'p5-left-arrow'
    s4.find(image).css width:28*this.scale,left:10,top:(this.windowHeight-image.height)/2, position: 'absolute','z-index': 100
  else if id == 'p5-right-arrow'
    s4.find(image).css width:28*this.scale,right:10,top:(this.windowHeight-image.height)/2, position: 'absolute','z-index': 100
  else if id == 'p5-b1'
    s4.find(image).css width:291*this.scale,left:57*this.scale,bottom:btnbottom,position:'absolute'
  else if id == 'p5-b2'
    s4.find(image).css width:291*this.scale,right:57*this.scale,bottom:btnbottom,position:'absolute'

p6p1 = ''
p6p2 = ''
p6try = ''

initP6 = (image, id)->
  s5 = $('#section5')
  if id == 'p6-bg'
    s5.prepend image
    image.width = $(window).width()
    p6p1 = s5.find(image)
    p6p1.addClass 'p6p1'
    p6p1.on 'click' , ->
      console.log('11');
      p6p1.hide()
      $('.p6p2').show()
    p6p1.css top:0,position:'absolute'
  else if id == 'p6-bg2'
    s5.prepend image
    image.width = $(window).width()
    p6p2 = s5.find(image)
    p6p2.hide()
    p6p2.addClass 'p6p2'
    p6p2.css top:0,position:'absolute',display:'none'
  else if id == 'p6-try'
    s5.append image
    s5.find(image).addClass 'p6p2'
    p6try = s5.find(image)
    s5.find(image).on 'click', ->
      p6p1.show()
      $('.p6p2').hide()
    s5.find(image).css bottom:400*this.scale,width:this.windowWidth/2,left:this.windowWidth/4,position:'absolute',display:'none'
  else if id == 'p6-share'
    s5.append image
    s5.find(image).addClass 'p6p2'
    s5.find(image).click ->
      $('#tip2').show()
    s5.find(image).css bottom:292*this.scale,width:this.windowWidth/2,left:this.windowWidth/4,position:'absolute',display:'none'
  else if id == 'p6-close'
    s5.append image
    css = width:74*this.scale,height:74*this.scale,top:20*this.scale,right:20*this.scale,position:'absolute'
    s5.find(image).css css
    s5.find(image).on 'click', ->
      console.log 'close'
      wx.closeWindow()
  else if id == 'p6-tip2'
    image.width = $(window).width()
    $('#tip2').append image

videoEnded = ->

initP2 = (image, id)->
  s1 = $('#section1')
  if id == 'p2-bg'
    image.width = $(window).width()
    s1.prepend image
  else if id == 'p2-video'
    image.width = $(window).width()
    s1.prepend image
    s1.find(image).click = ->
      video = document.getElementById('video')
      $('#video').show();
      if (video.paused)
        video.width = $(window).width()
        video.height = $(window).height()
        video.play()
      else
        video.pause();
        video.width = 0;
    s1.find(image).css top:this.windowHeight/2-(image.width*image.height/750)/2,position:'absolute'

handleFileLoad = (event)->
  image = event.result
  item = event.item
  if item.id.indexOf('p3') != -1
    initP3 image, item.id
  else if item.id.indexOf('p2') != -1
    initP2 image, item.id
  else if item.id == 'p4'
    s3 = $('#section3')
    image.width = $(window).width()
    s3.prepend image
  else if item.id == 'share-tip'
    image.width = $(window).width()
    $('#tip').prepend image
  else if item.id.indexOf('p5') != -1
    initP5 image, item.id
  else if item.id.indexOf('p6') != -1
    initP6 image, item.id
  else if item.id.indexOf('t') != -1
    initP1 image, item.id

load = ->

  preload = new createjs.LoadQueue()
  preload.on("progress", handleProgress)
  preload.on("complete", handleComplete)
  preload.on("fileload", handleFileLoad)
  preload.loadManifest(manifest1, true, 'imgs/home/')

load()