(function(){var e;e={init:function(){return this.windowWidth=$(window).width(),this.windowHeight=$(window).height(),this.scale=this.windowWidth/640,e.position($("#share"),540,80,50,779),e.position($("#share_close"),51,52,40,40),$("#numbers").css({position:"absolute",width:"100%","text-align":"center",top:282*this.scale,color:"#F7E3B2"}),$("#share").click(function(){return $("#share_pop").show()}),$("#share_close").click(function(){return $("#share_pop").hide()})},position:function(e,t,n,r,i){return e.css({position:"absolute",width:t*this.scale,height:n*this.scale,top:i*this.scale,left:r*this.scale})}},e.init()}).call(this);