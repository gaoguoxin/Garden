//= require global
//= require weixin
$(function(){
	wx.config({
		debug: true,
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
				}
			}
		});
	})	
})