import "bootstrap";
import { userAutocomplete } from '../plugins/user_autocomplete';
import { ellipsizeTextBox } from '../components/truncate';


ellipsizeTextBox(".card-title", ".card-title-original");

window.onresize = function(event){
    ellipsizeTextBox(".card-title", ".card-title-original");
}

userAutocomplete();


