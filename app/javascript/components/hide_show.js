const hideShow = () => {

    const dateFilterButton = document.getElementById('filter-btn');
    const dateFilter = document.getElementById('filter-wrap');

    dateFilterButton.addEventListener("click", function() {
      dateFilter.style.display = (dateFilter.dataset.toggled ^= 1) ? "block" : "none";
    });
}

export { hideShow };
