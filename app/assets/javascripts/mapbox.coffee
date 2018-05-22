# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
mapbox_api = ->
  #renderizzazione mappa su div #map
  mapboxgl.accessToken = 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A'
  map = new (mapboxgl.Map)(
    container: 'map'
    center: [
      12.4781985
      42.2058305
    ]
    style: 'mapbox://styles/mapbox/streets-v9'
    zoom: 2)
  #Abilita la ricerca delle località su mappa
  map.addControl new MapboxGeocoder(accessToken: 'pk.eyJ1IjoibGV0c2ZlZCIsImEiOiJjamhkamxmYXcwNTBvMzBva3VyOG50NjFtIn0.EuqkJJgJMWazgpxc6YJp4A')
  #Traccia l'user via GPS e abilita il centramento della mappa sulla posizione dell'user
  map.addControl new (mapboxgl.GeolocateControl)(
    positionOptions: enableHighAccuracy: true
    trackUserLocation: true)
  #Codice che servirà ad aggiungere i puntini sulla mappa delle rooms.
  map.on 'load', ->
    map.addLayer
      'id': 'points'
      'type': 'symbol'
      'source':
        'type': 'geojson'
        'data':
          'type': 'FeatureCollection'
          'features': [ {
            'type': 'Feature'
            'geometry':
              'type': 'Point'
              'coordinates': [
                12.602005004882812
                42.178670521216
              ]
            'properties':
              'title': 'Room1'
              'icon': 'harbor'
          } ]
      'layout':
        'icon-image': '{icon}-15'
        'text-field': '{title}'
        'text-font': [
          'Open Sans Semibold'
          'Arial Unicode MS Bold'
        ]
        'text-offset': [
          0
          0.6
        ]
        'text-anchor': 'top'
    return
  return

# ---
# generated by js2coffee 2.2.0
