(function(){var e;e={init:function(){return this.windowWidth=$(window).width(),this.windowHeight=$(window).height(),this.scale=this.windowWidth/640,e.position($("#form"),520,469,56,200),$(".field").css({width:520*this.scale,height:100*this.scale}),$(".field input").css({width:440*this.scale,height:100*this.scale,"padding-left":40*this.scale}),$(".verify_btn").css({width:180*this.scale,height:100*this.scale}),e.position($(".verify_btn"),180,100,396,$("#code_field").offset().top/this.scale),$(".verify_text").css({height:100*this.scale,"line-height":100*this.scale+"px",padding:0}),$(".verify_btn").click(function(){return console.log("send code")}),$(".submit").css({width:520*this.scale,height:100*this.scale})},position:function(e,t,n,r,i){return e.css({position:"absolute",width:t*this.scale,height:n*this.scale,top:i*this.scale,left:r*this.scale})}},e.init()}).call(this);