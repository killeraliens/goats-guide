import "bootstrap";
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { containThisSize } from '../components/contain_this';
import { userAutocomplete } from '../plugins/user_autocomplete';
import { initMapbox } from '../plugins/init_mapbox';
import { hideShow } from '../components/hide_show';



hideShow();
initMapbox();
userAutocomplete();
containThisSize();


function callHashCh() {
  console.log('hash changed!!');
}

window.addEventListener('hashchange', callHashCh(), false);



// $(document).ready( function(){
//   containThisSize();
//   console.log('document ready');
// });
window.onload="containThisSize()";

// initMapbox();

//initMapbox();



