const ellipsizeTextBox = (claA, claH) => {
  // alert('yo');
  const els = document.querySelectorAll(claA);
  const elsH = document.querySelectorAll(claH);
  for (let i = 0; i <= els.length; i++ ) {
    let el = els[i];
    let elH = elsH[i];
    el.innerHTML = elH.innerHTML;
    let wordArray = el.innerHTML.split(' ');
    while(el.scrollHeight > el.offsetHeight) {
        wordArray.pop();
        el.innerHTML = wordArray.join(' ') + '...';
     }
  };
}


export { ellipsizeTextBox };

