import places from 'places.js';

const userAutocomplete = () => {
  const cityInstance = places({
    container: document.getElementById('user_city'),
    type: 'city',
    templates: {
      value: function(suggestion) {
        return suggestion.name;
      }
    }
  });

  cityInstance.on('change', function resultSelected(e) {
    document.getElementById('user_city').value = e.suggestion.name || '';
    document.getElementById('user_state').value = e.suggestion.administrative || '';
    document.getElementById('user_country').value = e.suggestion.countryCode.toUpperCase() || '';
  });
};

// city state country as single string
// const userAutocomplete = () => {
//   const city = document.getElementById('user_city');
//   if (city) {
//     places({
//       container: city,
//       templates: {
//         value: function(suggestion) {
//           return suggestion.name + ', ' + suggestion.administrative + ', ' + suggestion.countryCode.toUpperCase();
//         }
//       }
//     }).configure({
//       type: 'city',
//       aroundLatLngViaIp: false,
//     });
//   }
// };

//returns full address
// const initAutocomplete = () => {
//   const addressInput = document.getElementById('venue_info');
//   if (addressInput) {
//     places({ container: addressInput });
//   }
// };

//returns city only
// const initAutocomplete = () => {
//   const city = document.getElementById('venue_info');
//   if (city) {
//     places({
//       container: city,
//       templates: {
//         value: function(suggestion) {
//           return suggestion.name;
//         }
//       }
//     }).configure({
//       type: 'city',
//       aroundLatLngViaIp: false,
//     });
//   }
// };

//returns country
// const initAutocomplete = () => {
//   const city = document.getElementById('venue_info');
//   if (city) {
//     places({
//       container: city,
//       templates: {
//         suggestion: function(suggestion) {
//           return '<i class="flag ' + suggestion.countryCode + '"></i> ' +
//           suggestion.highlight.name;
//         }
//       }
//     }).configure({
//       type: 'country',
//       aroundLatLngViaIp: false,
//     });
//   }
// };
export { userAutocomplete };
