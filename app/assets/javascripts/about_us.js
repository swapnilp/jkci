function loadMap() {
    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
	markers = handler.addMarkers([
	    {
		"lat": 17.059331,
		"lng": 74.276281,
		"zoom": 15,
		"picture": {
		    "url": "https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13028-64.png",
		    "width":  36,
		    "height": 36
		},
		"infowindow": "JKSCIENCE Academy <br />Islampur<br />ph - 02342(220364)"
	    }
	]);
	handler.bounds.extendWith(markers);
	handler.fitMapToBounds();
	handler.getMap().setZoom(16);
    });
}
