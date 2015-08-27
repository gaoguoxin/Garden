$(function(){
	function initialize(){  
	  var mp = new BMap.Map('map');  
	  mp.centerAndZoom(new BMap.Point(window.position[0], window.position[1]), 11);  
	}
	  
	function loadScript(){  
	  var script = document.createElement("script");  
	  script.src = "http://api.map.baidu.com/api?v=1.5&ak=" + window.ak + "&callback=initialize"; 
	  document.body.appendChild(script);  
	}  
	loadScript(); 	
})