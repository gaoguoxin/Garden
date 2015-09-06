$(function(){

            //设置main-table min高度,实际宽度
            $(".main-pannel").css("min-height",$(".sidebar").innerHeight ()-$(".main-pannel").offset().top-20+"px");
            $(".main-pannel").css("width",$(window).width()-343+"px");
    
	if($('#map').length > 0 ){
    	var map = new BMap.Map("map", { mapType: BMAP_HYBRID_MAP,enableMapClick:false });  
    	map.centerAndZoom(new BMap.Point(116.30, 39.96), 14);
    	map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_SATELLITE_MAP ]}));         
    	map.setCurrentCity("北京");

    	var styleOptions = {
    	    strokeColor:"red",
    	    fillColor:"red",
    	    strokeWeight: 3,
    	    strokeOpacity: 0.8,
    	    fillOpacity: 0.6,
    	    strokeStyle: 'solid'
    	}

    	//如果某块绿地已经做过地图标记则显示
    	if(window.p_center[0] && window.p_center[1]){
    		var marker = new BMap.Marker(new BMap.Point(window.p_center[0], window.p_center[1]));
    		map.centerAndZoom(new BMap.Point(window.p_center[0], window.p_center[1]), 14);
    		map.addOverlay(marker); 
    		marker.setAnimation(BMAP_ANIMATION_BOUNCE);
    		var lines = [];
    		$.each(window.polygons,function(){
    			var lng = this[0];
    			var lat = this[1];
    			lines.push(new BMap.Point(lng, lat));
    		})
			var polyline = new BMap.Polygon(lines,styleOptions);
			map.addOverlay(polyline);

			var markerMenu=new BMap.ContextMenu();
			markerMenu.addItem(new BMap.MenuItem('删除',function(){
				map.removeOverlay(polyline);
				map.removeOverlay(marker);
				window.pgs = [];
			}));
			polyline.addContextMenu(markerMenu);
    	}else{
    		map.centerAndZoom(new BMap.Point(116.30, 39.96), 14);
    	}

    	var drawingManager = new BMapLib.DrawingManager(map, {
    	    isOpen: false,
    	    enableDrawingTool: true,
    	    drawingToolOptions: {
    	        anchor: BMAP_ANCHOR_TOP_LEFT,
    	        offset: new BMap.Size(5, 5),
    	        drawingModes:[BMAP_DRAWING_POLYGON]  	        
    	    },
    	    polygonOptions:styleOptions
    	});  
    	drawingManager.addEventListener('polygoncomplete', function(e,overlay){
			var removeOlerlay = function(e,ee,overlay){
				map.removeOverlay(overlay);
			}
			var markerMenu=new BMap.ContextMenu();
			markerMenu.addItem(new BMap.MenuItem('删除',removeOlerlay.bind(overlay)));
			overlay.addContextMenu(markerMenu);

			var paths = overlay.getPath();
    	});    	    	
	}

	$('.green_type').click(function(){
		var t   = $(this).data('type');
		var txt = $(this).text();
		$('#greenbelt_type').val(t)
		$('#dropdownMenu1 span.type').text(txt)	
	})
	
	$('.btn-block').click(function(e){
		e.preventDefault();
		var connects = [
			{name:$.trim($('#contact1').val()),mobile:$.trim($('#mobile1').val()),email:$.trim($('#email1').val())},
			{name:$.trim($('#contact2').val()),mobile:$.trim($('#mobile2').val()),email:$.trim($('#email2').val())}
		];
		var gid = window.location.href.split('greenbelts/')[1].split('/')[0];
		data = {
			name:$.trim($('#greenbelt_name').val()),
			acreage:$.trim($('#greenbelt_acreage').val()),
			type:$('#greenbelt_type').val(),
			plants:$.trim($('#greenbelt_plants').val()),
			description:$.trim($('#greenbelt_description').val()),
			organization:$.trim($('#greenbelt_organization').val()),
			connects:connects,
			polygons:window.pgs  ?  window.pgs : window.polygons
			 
		}
		$.post('/admin/greenbelts/change',{id:gid,greenbelt:data},function(retval){
			if(retval.success){
				window.location.href= '/admin/greenbelts';
			}
		})
	})
})