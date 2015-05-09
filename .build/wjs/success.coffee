Base =
  init : ->
    this.windowWidth = $(window).width();
    this.windowHeight = $(window).height();
    this.scale = this.windowWidth/640;

    Base.position($('#share'),540,80,50,779)
    Base.position($('#share_close'),51,52,40,40)
#    Base.position($('#qrcode'),172,172,344,941)
    $('#numbers').css(position:'absolute',width:'100%','text-align':'center',top:282*this.scale,color:'#F7E3B2')

    $('#share').click ->
      $('#share_pop').show()

    $('#share_close').click ->
      $('#share_pop').hide()


  position : (item,width,height,x,y)->
    item.css(position:'absolute',width:width*this.scale,height:height*this.scale,top:y*this.scale,left:x*this.scale)

Base.init()