import "bootstrap";
import { userAutocomplete } from '../plugins/user_autocomplete';
import { ellipsizeTextBox } from '../components/truncate';


// ellipsizeTextBox(".card-title", ".card-title-original");
// ellipsizeTextBox(".card-location-row", ".card-location-row-original");


window.onresize = function(event){
    ellipsizeTextBox(".card-title", ".card-title-original");
    ellipsizeTextBox(".card-location-row", ".card-location-row-original");
}



userAutocomplete();


