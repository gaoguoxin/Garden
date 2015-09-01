$(function(){
	if($('#map').length > 0 ){
    	var map = new BMap.Map("map", { mapType: BMAP_HYBRID_MAP });  
    	map.centerAndZoom(new BMap.Point(116.30, 39.96), 14);
    	map.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_SATELLITE_MAP ]}));         
    	map.setCurrentCity("北京");


		var overlaycomplete = function(e){
    	    drawingManager.close();
			console.log(BMapLib.GeoUtils.getPolygonArea(e.overlay))
    	};
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
    	drawingManager.addEventListener('overlaycomplete', overlaycomplete);    	    	
	}
})