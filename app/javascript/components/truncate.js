const ellipsizeTextBox = (claA, claH) => {

  const els = document.querySelectorAll(claA);
  const elsH = document.querySelectorAll(claH);

  for (let i = 0; i <= els.length; i++ ) {
    let el = els[i];
    let elH = elsH[i];
    el.innerHTML = elH.innerHTML;
    let wordArray = el.innerHTML.split(' ');

    let ii=0;
    while(el.scrollHeight >= el.offsetHeight) {
        wordArray.pop();
        el.innerHTML = wordArray.join(' ') + '...';
        if(ii++ >= 5) break;
     }
  };
}


export { ellipsizeTextBox };


