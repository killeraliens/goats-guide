const hideShow = () => {

  const dateFilterButton = document.getElementById('filter-btn');
  const dateFilter = document.getElementById('filter-wrap');
  dateFilterButton.addEventListener("click", function() {
    dateFilter.style.display = (dateFilter.dataset.toggled ^= 1) ? "block" : "none";
    // dateFilter.classList.toggle("block");
  });
//   function containThisSize() {
//   // const containThis = document.getElementById('contain-this');
//   // const desktopFlexes = document.getElementsByClassName('contain-this');
//   // if (document.querySelector(`${containThis}:has(> ${desktopFlexes})`)) {
//   //   console.log('YES IT DOES');
//   // }
//   console.log('YES IT DOES');
// }
// containThisSize();
}

export { hideShow };
