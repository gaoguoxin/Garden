$(function(){
	//初始化地图
	function init(){
		alert(window.position[0]);
		alert(window.position[1]);  	
		var mp = new BMap.Map('map'); 
		mp.centerAndZoom(new BMap.Point(116.404, 39.915), 11);  
	}	
	init(); 	
})