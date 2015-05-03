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
]

init = ->
  this.windowWidth = $(window).width()
  this.windowHeight = $(window).height()
  this.scale = this.windowWidth/750
  top1 = (this.windowHeight-($('#loading-img').height()+$('#loading-label').height()+30))/2
  $('#loading-img').css(top:top1)
  top2 = top1+$('#loading-img').height()+30
  $('#loading-label').css(top:top2)
  $('#fullpage').hide()

  top3 = (this.windowHeight-722*this.scale)/2
  $('#p3l').css width:28*this.scale,left:10,top:(this.windowHeight-$('#p3l').height())/2
  $('#p3r').css width:28*this.scale,right:10,top:(this.windowHeight-$('#p3r').height())/2
  $('.p3s').css width:750*this.scale,top:top3,position:'absolute', 'z-index':100
  $('#p3top').css width:432*this.scale,top:90*this.scale,left:178*this.scale,position:'absolute', 'z-index':100
  ltop = top3+722*this.scale-10 - 38*this.scale
  $('#p3love').css width:43*this.scale,left:23*this.scale,top:ltop,position:'absolute', 'z-index':100
  stop = top3+722*this.scale-10-76*this.scale
  $('#p3share').css width:54*this.scale,right:23*this.scale,top:stop,position:'absolute', 'z-index':100
  p3w = 316*this.scale
  $('#p3btn').css top:(722*this.scale+top3-8),width:p3w,left:(this.windowWidth-p3w)/2,position:'absolute'
  p3bw = 175*this.scale
  $('#p3bottom').css bottom:75*this.scale,width:p3bw,left:(this.windowWidth-p3bw)/2,position:'absolute', 'z-index':100
  $('#love-label').css left:70*this.scale,top:ltop+5

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

handleFileLoad = (event)->
  image = event.result
  item = event.item
  if item.id.indexOf('t') != -1
    initP1(image, item.id)
  else if item.id == 'p2'
    s1 = $('#section1')
    image.width = $(window).width()
    s1.prepend image

load = ->

  preload = new createjs.LoadQueue()
  preload.on("progress", handleProgress)
  preload.on("complete", handleComplete)
  preload.on("fileload", handleFileLoad)
  preload.loadManifest(manifest1, true, 'imgs/home/')

load()