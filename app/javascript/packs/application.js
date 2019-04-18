import "bootstrap";
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { userAutocomplete } from '../plugins/user_autocomplete';
import { initMapbox } from '../plugins/init_mapbox';

initMapbox();
userAutocomplete();
