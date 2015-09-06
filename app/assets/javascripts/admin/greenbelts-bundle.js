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
})