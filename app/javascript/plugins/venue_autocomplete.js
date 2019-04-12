import places from 'places.js';

const venueInstance = places({
  container: document.querySelector('#venue_street'),
  type: 'address',
  templates: {
    value: function(suggestion) {
      return suggestion.name;
    }
  }
});

venueInstance.on('change', function resultSelected(e) {
  document.getElementById('venue_street').value = e.suggestion.name || '';
  document.getElementById('venue_city').value = e.suggestion.city || '';
  document.getElementById('venue_state').value = e.suggestion.administrative || '';
  document.getElementById('venue_country').value = e.suggestion.countryCode.toUpperCase() || '';
});

export { venueInstance };
