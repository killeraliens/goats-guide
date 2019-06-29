const containThisSize = () => {
  //const containThis = document.getElementById('contain-this');

  //document.getElementById('contain-this').style.width = "600px";
document.addEventListener('DOMContentLoaded', function() {
  document.getElementById('contain-this').classList.add('contain-this-more');
  if (document.body.querySelector(".desktop-flex")) {
    console.log("leaave full size");
    document.getElementById('contain-this').classList.remove('contain-this-more');
    // document.getElementById('contain-this').classList.add('contain-this');
  }

  }, false);



}

export { containThisSize };
