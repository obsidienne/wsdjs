export default class search {
  constructor() {
    var self = this;

    document.addEventListener("click", function (e) {
      if (e.target && e.target.matches("#search-input")) {
        self._show_search();
      }
      if (e.target && e.target.closest('.search-container') == null) {
        self._hide_search();
      }
    })

    var timeout;
    document.addEventListener("keyup", function (e) {
      if (e.target && e.target.matches("#search-input")) {
        clearTimeout(timeout);
        timeout = setTimeout(function () {
          self._search();
        }, 50);
      }
    })
  }

  _search(cl) {
    let query = document.getElementById("search-input").value;
    fetch(`/search?q=${query}`, {
        credentials: 'include'
      })
      .then((response) => {
        if (response.ok) {
          return response.text();
        } else {
          console.log('Mauvaise réponse du réseau');
        }
      })
      .then((data) => {
        document.querySelector(".search-results-container").innerHTML = data;
      })
      .catch(function (error) {
        console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
      });
  }

  _show_search() {
    let search_container = document.querySelector(".search-container");
    search_container.classList.add("focused");
  }

  _hide_search() {
    // remove focus
    var elements = document.querySelectorAll(".focused");
    Array.prototype.forEach.call(elements, function (el, i) {
      el.classList.remove("focused");
    });

    // remove data from the result list
    var container = document.querySelector(".search-results-container");
    if (container) container.innerHTML = "";

    // remove searched string
    var search = document.getElementById("search-input");
    if (search) search.value = "";
  }
}