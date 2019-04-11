import places from 'places.js';

const userAutocomplete = () => {
  const cityStateCountry = document.getElementById('user_city');
  if (cityStateCountry) {
    places({
      container: cityStateCountry,
      templates: {
        value: function(suggestion) {
          return suggestion.name + ', ' + suggestion.administrative + ', ' + suggestion.countryCode.toUpperCase();
        }
      }
    }).configure({
      type: 'city',
      aroundLatLngViaIp: false,
    });
  }
};
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
