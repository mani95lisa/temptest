fnOver = ->
  if $(this).attr('clickable')
    $(this).addClass 'onclick'
  $(this).addClass 'active'
fnOut = ->
  if $(this).attr('clickable')
    $(this).removeClass 'onclick'
  $(this).removeClass 'active'

$('.front').hover(fnOver, fnOut)

w = $('.s4-img').width()
$('.s4-img').animate {left:-w, opacity:0}, duration:300


