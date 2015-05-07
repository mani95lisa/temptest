manifest1 = [
  {src: "1.jpg"}
  {src: "2.jpg"}
]


handleProgress = (event)->
  percent = event.loaded
  console.log('P:'+percent);
  $('#loading-label').text(Math.round(percent * 100) + '%')
handleComplete = (event)->
  console.log('Loaded');

load = ->

  preload = new createjs.LoadQueue()
  preload.on("progress", handleProgress)
  preload.on("complete", handleComplete)
  preload.loadManifest(manifest1, true, 'imgages/')

#load()