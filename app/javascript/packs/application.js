import "bootstrap";
import 'mapbox-gl/dist/mapbox-gl.css';
import { userAutocomplete } from '../plugins/user_autocomplete';
import { initMapbox } from '../plugins/init_mapbox';

initMapbox();
userAutocomplete();



