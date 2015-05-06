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
  {src: "p2.jpg", id: "p2"}
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
]

init = ->
  this.windowWidth = $(window).width()
  this.windowHeight = $(window).height()
  this.scale = this.windowWidth/750
  h = 153*this.windowWidth*0.63/466
  top1 = (this.windowHeight-(h+$('#loading-label').height()+30))/2
  $('#loading-img').css(top:top1)
  top2 = top1+h+30
  $('#loading-label').css(top:top2)
  $('#fullpage').hide()
  $('#tip').hide()
  $('#tip').click ->
    $('#tip').hide()
  $('#p5-label').css bottom:62*this.scale

init()

handleProgress = (event)->
  percent = event.loaded
  $('#loading-label').text(Math.round(percent*100)+'%')
handleComplete = (event)->
  s1 = $('#section0')
  arr = s1.find('img');
  arr.animate {deg:180,opacity:1}, duration:1500, step:(now)->
    if now > 1
      arr.css transform: 'rotateX(' + (180-now) + 'deg)', '-webkit-transform':'rotateX(' + (180-now) + 'deg)'
#  animate = ->
#    i--
#    if i > 0
#      deg = 0
#      img = s1.find(arr[i])
#      img.animate {deg:180,opacity:1}, duration:300, step:(now)->
#        img.css transform: 'rotateX(' + now + 'deg)'
#      , complete:->
#          animate()
#  animate()
  $('#loading-img').animate opacity:0, 800
  $('#loading-label').animate opacity:0, 800, ->
    $('#loading-img').remove()
    $('#loading-label').remove()
    $('#fullpage').show()
#  setTimeout ->
#    $.fn.fullpage.moveTo(5,1);
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
  s1.find(image).css position:'absolute',left:x,top:y,opacity:0,deg:180,'transform-origin': '50% 0% 0px',transform: 'rotateX(180deg)'
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
    $('#'+id).find(image).css width:602*this.scale,left:83*this.scale,top:269*this.scale,position:'relative'
  if id == 'p5-bg'
    image.width = $(window).width()
    s4.find(image).css top:0,position:'absolute'
  else if id == 'p5-left-arrow'
    s4.find(image).css width:28*this.scale,left:10,top:(this.windowHeight-image.height)/2, position: 'absolute','z-index': 100
  else if id == 'p5-right-arrow'
    s4.find(image).css width:28*this.scale,right:10,top:(this.windowHeight-image.height)/2, position: 'absolute','z-index': 100
  else if id == 'p5-b1'
    s4.find(image).css width:291*this.scale,left:57*this.scale,bottom:150*this.scale,position:'absolute'
  else if id == 'p5-b2'
    s4.find(image).css width:291*this.scale,right:57*this.scale,bottom:150*this.scale,position:'absolute'

handleFileLoad = (event)->
  image = event.result
  item = event.item
  if item.id.indexOf('p3') != -1
    initP3 image, item.id
  else if item.id == 'p2'
    s1 = $('#section1')
    image.width = $(window).width()
    s1.prepend image
  else if item.id == 'p4'
    s3 = $('#section3')
    image.width = $(window).width()
    s3.prepend image
  else if item.id == 'share-tip'
    image.width = $(window).width()
    $('#tip').append image
  else if item.id.indexOf('p5') != -1
    initP5 image, item.id
  else if item.id.indexOf('t') != -1
    initP1 image, item.id

load = ->

  preload = new createjs.LoadQueue()
  preload.on("progress", handleProgress)
  preload.on("complete", handleComplete)
  preload.on("fileload", handleFileLoad)
  preload.loadManifest(manifest1, true, 'imgs/home/')

load()