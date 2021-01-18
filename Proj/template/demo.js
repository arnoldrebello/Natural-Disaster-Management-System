var platform = new H.service.Platform({
	apikey: 'pWNuw3o2tRNfH4tUMvEkaDYPmt8PHkKf-ltgj78tH0E'
});

// Obtain the default map types from the platform object
var maptypes = platform.createDefaultLayers();

// Instantiate (and display) a map object:
var map = new H.Map(document.getElementById('map'), maptypes.vector.normal.map, {
	zoom: 10,
	center: { lng: 13.4, lat: 52.51 }
});
