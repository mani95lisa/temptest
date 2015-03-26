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
    $('.verify_btn').click ->
      console.log 'send code'

    $('.submit').css(width:520*this.scale,height:100*this.scale)

  position : (item,width,height,x,y)->
    item.css(position:'absolute',width:width*this.scale,height:height*this.scale,top:y*this.scale,left:x*this.scale)

Base.init()