home_arr = []
page_index = 0
slide_index = 1
manifest1 = [
  {src: "tip2.jpg", id: "tip2"}
  {src: "tip3.jpg", id: "tip3"}
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
  {src: "p6-bg1.jpg", id: "p6-bg1"}
  {src: "p6-gift.png", id: "p6-gift"}
  {src: "p6-bg3.jpg", id: "p6-bg3"}
  {src: "p6-sub.png", id: "p6-sub"}
]

i = 0
while i<9
  i++
  if i != 5
    manifest1.push src: "p3-t"+i+".jpg", id: "p3-t"+i
    manifest1.push src: "p3-m"+i+".jpg", id: "p3-m"+i

while i<5
  i++
  manifest1.push src: "p5-i"+i+".png", id: "p5-i"+i

count = 0
intv = ''

p1 = ->
  lw = this.windowWidth*0.63
  lh = lw*153/466
  $('#loading-img').css(width:this.windowWidth*0.63);
  top1 = (this.windowHeight-lh)/2
  $('#loading-img').css(top:top1,left:this.windowWidth/2-lw/2)
  top2 = top1+lh+30
  $('#loading-label').css(top:top2)

refresh = ->
  if count > 10
    clearInterval intv
    return
  p1()
  $('.swiper-container').css width:this.windowWidth,height:this.windowHeight
  $('.swiper-wrapper').css width:this.windowWidth,height:this.windowHeight
  count++

intv = setInterval refresh, 500

init = ->
  this.windowWidth = $(window).width()
  this.windowHeight = $(window).height()
  this.ww = $(window).width()
  this.wh = $(window).height()
  this.scale = this.windowWidth/750
  $('.section').hide()
  $('#tip').hide()
  $('#tip').click ->
    $('#tip').hide()
  $('#tip2').hide()
  $('#tip2').click ->
    $('#tip2').hide()
  $('#tip3').hide()
  $('#tip3').click ->
    $('#tip3').hide()
  $('#p5-label').css bottom:62*this.scale
  p1()

init()

playing = false
max_page = 5

upHandler = ->
  if playing
    return
  toPageSlide(true)

downHandler = ->
  if playing
    return
  toPageSlide(false)

toPageSlide = (fromtop,page, slide)->
  if (fromtop && page_index >= 5) || (!fromtop && page_index <= 0)
    return

  if videoplaying
    playVideoImg.show()
    video = document.getElementById('video')
    video.pause()
    $('#video').hide()
    videoplaying = false

  slide_index = slide if slide
  playing = true
  old = page_index
  if page
    page_index = page
  else
    page_index = if fromtop then page_index+1 else page_index-1
  hidetop = if fromtop then -this.wh else this.wh
  hidec = if fromtop then 'animated zoomOutUp' else 'animated zoomOutDown'
  $('#section'+old).addClass hidec
  $('#section'+old).css 'z-index':-100
  $('#section'+old).one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
    $('#section'+old).removeClass hidec
    $('#section'+old).css top:hidetop
    playing = false
  showtop = if fromtop then this.wh else -this.wh

  $('#section'+page_index).show()
  $('#section'+page_index).css top:0, 'z-index':0
  toc = if !fromtop then 'animated slideInDown' else 'animated slideInUp'
  console.log hidec, toc
  $('#section'+page_index).one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
    $('#section'+page_index).removeClass toc
  $('#section'+page_index).addClass toc
#  $('#section'+page_index).animate {top:0}, 500
  if page_index == 2
    if !slide
      slide = 1
    selectP3Slide(false, slide)
  else if page_index == 4
    slide_index = 1
    $('.slide').hide()
    $('#p5-i1').show()

leftHandler = ->
  if playing
    return
  if page_index != 2 && page_index != 4
    return
  playing = true
  if page_index == 2
    selectP3Slide(true)
  else if page_index == 4
    selectP4Slide(true)

selectP4Slide = (left)->
  old = slide_index
  if !left
    slide_index = if slide_index > 1 then slide_index - 1 else 5
  else
    slide_index = if slide_index < 5 then slide_index + 1 else 1
  tol = if left then -this.ww else this.ww
  $('#p5-i' + old).animate left: tol, 500, ->
    playing = false
  froml = if left then this.ww else -this.ww
  $('#p5-i' + slide_index).css left: froml, display:'block'
  $('#p5-i' + slide_index).animate left: 0, 500

selectP3Slide = (left,select)->
  old = slide_index
  if select
    slide_index = select
    if slide_index == 6
      slide_index = 7
    else if slide_index == 7
      slide_index = 6
  else
    if !left
      slide_index = if slide_index > 1 then slide_index - 1 else 8
    else
      slide_index = if slide_index < 8 then slide_index + 1 else 1
    if old == 5
      old = if left then 6 else 4
    if slide_index == 5
      slide_index = if left then slide_index+1 else slide_index-1
    tol = if left then -this.ww else this.ww
  if select
    playing = false
    console.log 'sl', old, select, slide_index
    $('.slide').hide()
    $('#p3-m' + slide_index).css left: 0, display:'block'
  else
    console.log(tol, left, old, slide_index)
    hidec = if left then 'animated zoomOutLeft' else 'animated zoomOutRight'
    $('#p3-m'+old).addClass hidec
    $('#p3-m'+old).css 'z-index':-100
    $('#p3-m'+old).one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      $('#p3-m'+old).removeClass hidec
      $('#p3-m'+old).css left:tol
      playing = false
#    $('#p3-m' + old).animate left: tol, 500, ->
#      playing = false
    froml = if left then this.ww else -this.ww

    toc = if left then 'animated slideInRight' else 'animated slideInLeft'
    console.log hidec, toc
    $('#p3-m' + slide_index).show()
    $('#p3-m' + slide_index).css left:0, 'z-index':0
    $('#p3-m' + slide_index).one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      $('#p3-m' + slide_index).removeClass toc
    $('#p3-m' + slide_index).addClass toc

#    $('#p3-m' + slide_index).css left: froml, display:'block'
#    $('#p3-m' + slide_index).animate left: 0, 500

rightHandler = ->
  if playing
    return
  if page_index != 2 && page_index != 4
    return
  playing = true
  if page_index == 2
    selectP3Slide(false)
  else if page_index == 4
    selectP4Slide(false)

handleProgress = (event)->
  percent = event.loaded
  $('#loading-label').text(Math.round(percent*100)+'%')
handleComplete = (event)->
  $('#loading-img').animate opacity:0, 800
  $('#loading-label').animate opacity:0, 800, ->
    $('#loading-img').remove()
    $('#loading-label').remove()
    $('#section0').show()
    s1 = $('#section0')
    arr = s1.find('img');
    #  arr.animate {deg:180,opacity:1}, duration:1500, step:(now)->
    #    if now > 1
    #      arr.css transform: 'rotateX(' + (180-now) + 'deg)', '-webkit-transform':'rotateX(' + (180-now) + 'deg)'
    i = arr.length
    cc = []
    animate = ->
      i--
      if i >= 0
        console.log i
        deg = 0
        img = s1.find(arr[i])
        img.animate {deg:180,opacity:1}, duration:300, step:(now)->
          if now > 1
            img.css transform: 'rotateX(' + (180-now) + 'deg)','-webkit-transform':'rotateX(' + (180-now) + 'deg)'
#            if now > 80 && cc.indexOf(i) == -1 && i>0
#              cc.push i
#              animate()
        , complete:->
          animate()
    animate()
    $(document).swipe(
      swipe:(event, direction)->
        console.log direction
        if direction == 'up'
          upHandler()
        else if direction == 'down'
          downHandler()
        else if direction == 'left'
          leftHandler()
        else
          rightHandler()
    )
#    toPageSlide(true, 5)
#    $('#section2').show()
#  setTimeout ->
#    $.fn.fullpage.moveTo(3,1);
#  , 1000

imgArr = []

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
  imgArr[id] = image
  s1.find(image).click showImg
  s1.find(image).css position:'absolute',left:x,top:y,opacity:0,deg:180,'transform-origin': '50% 0% 0px',transform: 'rotateX(180deg)','-webkit-transform':'rotateX(180deg)'
  home_arr.push w:w,h:h,x:x,y:y

showImg = (event)->
  for key, value of imgArr
    if value==event.target
      console.log 'Got:'+key
      id = key.replace('t', '')
      if id != 10
        toPageSlide true,2,parseInt(id)

loveNum = 0

loveItem = ->
  loveNum++
  $('#love-label').text('x'+loveNum)

initP3 = (image, id)->

  s2 = $('#section2')
  top3 = (this.windowHeight-722*this.scale)/2
  ltop = top3+722*this.scale-10 - 38*this.scale
  $('#love-label').css left:70*this.scale,top:ltop+5
  if id.indexOf('p3-t') != -1
    iiid = id.replace('p3-t', '')
    $('#p3-m'+iiid).prepend image
    $('#p3-m'+iiid).find(image).css width:432*this.scale,top:90*this.scale,left:178*this.scale,position:'relative', 'z-index':100
  else if id.indexOf('p3-m') != -1
    $('#'+id).prepend image
    $('#'+id).find(image).css width:750*this.scale,top:top3,position:'absolute', 'z-index':100
  else
    s2.append image
  if id == 'p3-left-arrow'
    s2.find(image).css width:28*this.scale,left:10,top:(this.windowHeight-image.height)/2, position: 'absolute','z-index': 100
  else if id == 'p3-right-arrow'
    s2.find(image).css width:28*this.scale,right:10,top:(this.windowHeight-image.height)/2, position: 'absolute','z-index': 100
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
    s2.find(image).on 'click', ->
      toPageSlide(false, 1)
    s2.find(image).css top:(722*this.scale+top3),width:p3w,left:(this.windowWidth-p3w)/2,position:'absolute'
  else if id == 'p3-bottom'
    p3bw = 175*this.scale
    s2.find(image).css bottom:75*this.scale,width:p3bw,left:(this.windowWidth-p3bw)/2,position:'absolute', 'z-index':100

initP5 = (image, id)->
  s4 = $('#section4')
  if id.indexOf('p5-i') == -1
    s4.prepend image
  else
    $('#'+id).append image
    it = if this.windowHeight < 550 then 160*this.scale else 180*this.scale
    $('#'+id).find(image).css width:this.windowWidth,left:0,top:it,position:'relative'
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

gotR = false

initP6 = (image, id)->
  s5 = $('#section5')
  $('#form').css width:278*this.scale,height:262*this.scale,left:302*this.scale,top:650*this.scale
  if id == 'p6-bg1'
    s5.prepend image
    image.width = $(window).width()
    p6p1 = s5.find(image)
    p6p1.addClass 'p6p1'
    p6p1.css top:0,position:'absolute'
  else if id == 'p6-gift'
    s5.append image
    gift = s5.find(image)
    gift.addClass 'p6p1 animated tada'
    gift.css {
      width: 367 * this.scale
      top: 554 * this.scale
      left: this.ww / 2 - 367 * this.scale / 2
      position: 'absolute'
      '-webkit-animation-duration': '3s'
      '-webkit-animation-delay': '2s'
      '-webkit-animation-iteration-count': 'infinite'
      'animation-duration': '3s'
      'animation-delay': '2s'
      'animation-iteration-count': 'infinite'
    }
    gift.on 'click', ->
      $('.p6p1').hide()
      r = Math.random()
      if gotR
        gotR = false
        $('.p6p3').show()
      else
        gotR = true
        $('.p6p2').show()

  else if id == 'p6-bg2'
    s5.prepend image
    image.width = $(window).width()
    p6p2 = s5.find(image)
    p6p2.hide()
    p6p2.addClass 'p6p2'
    p6p2.css top:0,position:'absolute',display:'none'
  else if id == 'p6-bg3'
    s5.prepend image
    image.width = $(window).width()
    p6p3 = s5.find(image)
    p6p3.hide()
    p6p3.addClass 'p6p3'
    p6p3.css top:0,position:'absolute'
  else if id == 'p6-sub'
    s5.append image
    s5.find(image).addClass 'p6p3'
    p6try = s5.find(image)
    s5.find(image).on 'click', ->
      $('#tip3').show()
    s5.find(image).css top:960*this.scale,width:this.windowWidth/2,left:this.windowWidth/4,position:'absolute',display:'none'
  else if id == 'p6-try'
    s5.append image
    s5.find(image).addClass 'p6p2'
    p6try = s5.find(image)
    s5.find(image).on 'click', ->
      $('.p6p1').show()
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

playVideoImg = ''
videoEnded = ->
  console.log 'end'
  $('#video').hide();
  playVideoImg.show()

videoplaying = false

initP2 = (image, id)->
  s1 = $('#section1')
  if id == 'p2-bg'
    image.width = $(window).width()
    s1.prepend image
  else if id == 'p2-video'
    image.width = $(window).width()
    s1.prepend image
    playVideoImg = s1.find(image)
    video = document.getElementById('video')
    $('#video').on 'click', ->
      alert 'v'
      playVideoImg.show()
      $('#video').hide();
      video.pause()
    s1.find(image).on 'click', ->
      playVideoImg.hide()
      $('#video').show()
      video.width = $(window).width()
      video.height = $(window).height()
      video.play()
      videoplaying = true
    s1.find(image).css top:this.windowHeight/2-(image.width*image.height/750)/2,position:'absolute'

handleFileLoad = (event)->
  image = event.result
  item = event.item
  if item.id == 'tip2'
    image.width = $(window).width()
    $('#tip2').append image
  else if item.id == 'tip3'
    image.width = $(window).width()
    $('#tip3').append image
  else if item.id.indexOf('p3') != -1
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
    console.log item.id
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