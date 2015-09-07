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
				}
			}
		});

		wx.getLocation({
		    type: 'wgs84',
		    success: function (res) {
		        var latitude = res.latitude; //纬度
		        var longitude = res.longitude; //经度
		        var speed = res.speed; //速度，以米/每秒计
		        var accuracy = res.accuracy; // 位置精度
				var translateCallback = function(pt){
					mp.centerAndZoom(pt, 17);
					var marker = new BMap.Marker(pt);
					mp.addOverlay(marker);
				}		        
				if($('#map').length > 0){
					var mp = new BMap.Map('map',{mapType: BMAP_HYBRID_MAP});
					var point = new BMap.Point(longitude, latitude);
					BMap.Convertor.translate(point,0,translateCallback);

    				var styleOptions = {
    				    strokeColor:"red",
    				    fillColor:"red",
    				    strokeWeight: 3,
    				    strokeOpacity: 0.8,
    				    fillOpacity: 0.6,
    				    strokeStyle: 'solid'
    				}

					$.get('/greenbelts/nearby',{lng:longitude,lat:latitude},function(res){
						$.each(res.data,function(idx,d){
    						var lines = [];
    						$.each(d.polygons,function(){
    							var lng = this[0];
    							var lat = this[1];
    							lines.push(new BMap.Point(lng, lat));
    						});
							var polyline = new BMap.Polygon(lines,styleOptions);
							mp.addOverlay(polyline);

							var opts = {
							  position : new BMap.Point(d.polygons[0][0],d.polygons[0][1]),
							  offset   : new BMap.Size(0,0)
							}
							var label = new BMap.Label(d.code + "号绿地", opts);
							label.setStyle({
								 color : "green",
								 fontSize : "12px",
								 height : "20px",
								 lineHeight : "20px",
								 fontFamily:"微软雅黑",
								 border:'0px',
								 backgroundColor:'transparent'
							});
							mp.addOverlay(label);
						})
					})
				}else{
					alert('地图不存在')
				}
		    }
		});
	})


		// test code start
		var mp = new BMap.Map('map',{mapType: BMAP_HYBRID_MAP});
		var point = new BMap.Point(116.34103, 39.9928255);
		mp.centerAndZoom(point, 17);
		var marker = new BMap.Marker(point);
		mp.addOverlay(marker);

    	var styleOptions = {
    	    strokeColor:"red",
    	    fillColor:"red",
    	    strokeWeight: 3,
    	    strokeOpacity: 0.8,
    	    fillOpacity: 0.6,
    	    strokeStyle: 'solid'
    	}

		$.get('/greenbelts/nearby',{lng:116.34103,lat:39.9928255},function(res){
			$.each(res.data,function(idx,d){
    			var lines = [];
    			$.each(d.polygons,function(){
    				var lng = this[0];
    				var lat = this[1];
    				lines.push(new BMap.Point(lng, lat));
    			})
				var polyline = new BMap.Polygon(lines,styleOptions);
				mp.addOverlay(polyline);

				var opts = {
				  position : new BMap.Point(d.polygons[0][0],d.polygons[0][1]),
				  offset   : new BMap.Size(0,0)
				}
				var label = new BMap.Label(d.code + "号绿地", opts);
					label.setStyle({
						 color : "green",
						 fontSize : "12px",
						 height : "20px",
						 lineHeight : "20px",
						 fontFamily:"微软雅黑",
						 border:'0px',
						 backgroundColor:'transparent'
					 });
				mp.addOverlay(label); 


			})
		})
		// test code end
	

})