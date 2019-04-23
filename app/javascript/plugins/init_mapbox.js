import mapboxgl from 'mapbox-gl';


// const initMapbox = () => {
//   const mapElement = document.getElementById('map');

//   if (mapElement) {
//     mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
//     const map = new mapboxgl.Map({
//       container: 'map',
//       style: 'mapbox://styles/killeraliens/cjujo0v2703j71fqray97kjad'
//     });
//     const markers = JSON.parse(mapElement.dataset.markers);
//     markers.forEach((marker) => {
//       new mapboxgl.Marker()
//       .setLngLat([ marker.lng, marker.lat ])
//       .addTo(map);
//     });
//     const fitMapToMarkers = (map, markers) => {
//       const bounds = new mapboxgl.LngLatBounds();
//       markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
//       map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
//     };

//     fitMapToMarkers(map, markers);
//   }
// };
const fitMapToMarkers = (map, features) => {
  const bounds = new mapboxgl.LngLatBounds();
  features.forEach(({ geometry }) => bounds.extend(geometry.coordinates));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) {
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/killeraliens/cjujo0v2703j71fqray97kjad'
    });


    map.on('load', function() {
      const events = JSON.parse(mapElement.dataset.events)
      map.addSource("events", {
        type: "geojson",
        // Point to GeoJSON data. This example visualizes all M1.0+ earthquakes
        data: events,
        cluster: true,
        clusterMaxZoom: 14, // Max zoom to cluster points on
        clusterRadius: 50 // Radius of each cluster when clustering points (defaults to 50)
      });

      map.addLayer({
        id: 'clusters',
        type: 'circle',
        source: 'events',
        filter: ['has', 'point_count'],
        paint: {
          'circle-color': [
            'step',
            ['get', 'point_count'],
            '#FF3100',
            100,
            '#FF3100',
            750,
            '#FF3100'
          ],
          'circle-radius': [
            'step',
            ['get', 'point_count'],
            20,
            100,
            30,
            750,
            40
          ]
        }
      });

      map.addLayer({
        id: 'cluster-count',
        type: 'symbol',
        source: 'events',
        filter: ['has', 'point_count'],
        layout: {
          'text-field': '{point_count_abbreviated}',
          'text-font': ['Arial Unicode MS Bold'],
          'text-size': 12
        },
        paint: {
          "text-color": "#ffffff"
        }
      });

      map.addLayer({
        id: 'unclustered-point',
        type: 'circle',
        source: 'events',
        filter: ['!', ['has', 'point_count']],
        paint: {
          'circle-color': '#FF3100',
          'circle-radius': 6,
          'circle-stroke-width': 0,
          'circle-stroke-color': '#fff',
        }
      });


      map.on('click', 'clusters', function (e) {
        const features = map.queryRenderedFeatures(e.point, { layers: ['clusters'] });
        const clusterId = features[0].properties.cluster_id;

        map.getSource('events').getClusterExpansionZoom(clusterId, function (err, zoom) {
          if (err) return;

          map.easeTo({
            center: features[0].geometry.coordinates,
            zoom: zoom
          });
        });
      });

      map.on('mouseenter', 'clusters', function () {
        map.getCanvas().style.cursor = 'pointer';
      });

      map.on('mouseleave', 'clusters', function () {
        map.getCanvas().style.cursor = '';
      });

      fitMapToMarkers(map, events.features);

    });
  }
};

export { initMapbox };
