import "bootstrap";
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { userAutocomplete } from '../plugins/user_autocomplete';
import { initMapbox } from '../plugins/init_mapbox';
import { hideShow } from '../components/hide_show';



hideShow();
initMapbox();
userAutocomplete();


function callHashCh() {
  console.log('hash changed!!');
}

window.addEventListener('hashchange', callHashCh(), false);



// $(document).ready( function(){
//   initMapbox();
//   console.log('document ready');
// });

// initMapbox();

//initMapbox();



