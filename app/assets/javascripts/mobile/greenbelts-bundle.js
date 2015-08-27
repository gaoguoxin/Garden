$(function(){
	function init(){
		//获取地理位置
		wx.getLocation({
		    type: 'wgs84',
		    success: function (res) {
		        var latitude = res.latitude; //纬度
		        var longitude = res.longitude; //经度
		        var speed = res.speed; //速度，以米/每秒计
		        var accuracy = res.accuracy; // 位置精度
		        var mp = new BMap.Map('map'); 
		        mp.centerAndZoom(new BMap.Point(longitude, latitude), 11);  
		    }
		}); 
	}	
	init(); 	
})