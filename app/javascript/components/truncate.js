const ellipsizeTextBox = (claA, claH) => {
  const els = document.querySelectorAll(claA);
  const elsH = document.querySelectorAll(claH);
  for (let i = 0; i < els.length; i++ ) {
    let el = els[i];
    let elH = elsH[i];
    el.innerHTML = elH.innerHTML;
    //let wordArray = el.innerHTML.split(' ');

    var str = elH.innerHTML;

    while(el.scrollHeight > el.offsetHeight) {
    //    wordArray.pop();
    //    el.innerHTML = wordArray.join(' ') + '...';

        var strCuttedOff = str.substring(0, str.length - 5);
        str = strCuttedOff;
        el.innerHTML = strCuttedOff + "...";

     }
  };
}



export { ellipsizeTextBox };


