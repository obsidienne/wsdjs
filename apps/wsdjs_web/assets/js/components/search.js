export default class search {
  constructor() {
    document.addEventListener("click", (e) => {
      if (e.target && e.target.matches("#search-input")) {
        this._show_search();
      }
      if (e.target && e.target.closest('.search-container') == null) {
        this._move_search();
        this._hide_search();
      }
    })

    var timeout;
    var self = this;

    document.addEventListener("keyup", (e) => {
      if (e.target && e.target.matches("#search-input")) {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
          this._search();
        }, 400);
      }
    })
  }

  _search(cl) {
    let el = document.getElementById("search-input");
    let playlist = el.dataset.playlist;
    let query = el.value;
    fetch(`/playlists/${playlist}/search?q=${query}`, {
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

  _move_search() {}
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