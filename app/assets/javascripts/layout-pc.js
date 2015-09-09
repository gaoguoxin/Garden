//= require global
//= require drawing
//= require geoUtils

$(function(){
	$(".nav-left").css("left",0-$(window).scrollLeft()+"px");
	$(".nav-right").css("left",0-$(window).scrollLeft()+"px");
	$(".welcome-head").css("left",0-$(window).scrollLeft()+"px");
	$(".sidebar").css("left",0-$(window).scrollLeft()+"px");
})

$(window).scroll(function(event){
	$(".nav-left").css("left",0-$(window).scrollLeft()+"px");
	$(".nav-right").css("left",0-$(window).scrollLeft()+"px");
	$(".welcome-head").css("left",0-$(window).scrollLeft()+"px");
	$(".sidebar").css("left",0-$(window).scrollLeft()+"px");
	if($('#map').length > 0 ){
		 $(".map-shade").css("top",$('#map').offset ().top+"px");
		 $(".map-shade").css("left",$('#map').offset ().left+"px");
	}
});