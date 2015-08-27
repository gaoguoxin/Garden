//= require global
//= require weixin
$(function(){
	wx.config({
		debug: false,
		appId: window.appid,
		timestamp: window.timestamp,
		nonceStr: window.noncestr,
		signature: window.signure,
		jsApiList: ['getLocation','chooseImage','previewImage','uploadImage','downloadImage']
	});
	wx.ready(function(){
		//检查是否支持指定的api
		wx.checkJsApi({
			jsApiList:['getLocation','chooseImage'],
			success:function(res){
				if(!res['checkResult']['getLocation']){
					alert('您的手机不支持定位功能');
					return false;
				}
				if(!res['checkResult']['chooseImage']){
					$('.choose-img').hide();
					return false;
					//$('.blog-modal').modal('hide');
				}
			}
		});
		//获取地理位置
		wx.getLocation({
		    type: 'wgs84',
		    success: function (res) {
		        var latitude = res.latitude; //纬度
		        var longitude = res.longitude; //经度
		        var speed = res.speed; //速度，以米/每秒计
		        var accuracy = res.accuracy; // 位置精度
		        alert(longitude);
		        alert(latitude);
		        //window.position = [longitude,latitude];
		    }
		});
	})	
})