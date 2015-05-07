manifest1 = [
  src:'01.jpg'
  src:'a3-s.png'
  src:'a4-s.png'
  src:'a7-s.png'
  src:'a8-s.png'
  src:'bg4.png'
  src:'bottom2.png'
  src:'a8-s.png'
]

i = 0
while i<5
  i++
  manifest1.push src:i+'.jpg'
  manifest1.push src:'p3-m'+i+'.png'
  manifest1.push src:'p3-t'+i+'.png'
  if i< 5
    manifest1.push src:'step-4-'+i+'.jpg'
i = 0
while i<8
  i++
  manifest1.push src:'a'+i+'.jpg'
  manifest1.push src:'is'+i+'.jpg'

handleProgress = (event)->
  percent = event.loaded
  console.log('P:'+percent);
  $('#loading-label').text(Math.round(percent * 100) + '%')
handleComplete = (event)->
  console.log('Loaded');
  $('#main').show();
  $('.sidebar').show();
  $('.tmall').show();

load = ->

  preload = new createjs.LoadQueue()
  preload.on("progress", handleProgress)
  preload.on("complete", handleComplete)
  preload.loadManifest(manifest1, true, 'images/')

load()

$('#main').hide()
$('.sidebar').hide()