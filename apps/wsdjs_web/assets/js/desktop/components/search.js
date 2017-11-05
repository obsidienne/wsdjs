import timeago from 'timeago.js';

export default class search {
  constructor() {
    var self = this;

    document.addEventListener("click", function(e) {
      if (e.target && e.target.matches("#search-input")) {
        self._show_search();
      }
      if (e.target && e.target.closest('.search-container') == null) {
        self._hide_search();
      }
    })

    var timeout;
    document.addEventListener("keyup", function(e) {
      if (e.target && e.target.matches("#search-input")) {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
          self._search();
        }, 50);
      }      
    })
  }

  _search(cl) {
    var query = document.getElementById("search-input").value;

    var request = new XMLHttpRequest();
    request.open('GET', '/search?q='+query, true);

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        document.querySelector(".search-results-container").innerHTML = this.response;
        new timeago().render(document.querySelectorAll(".search-results-container time.timeago"));
      } else {
        document.querySelector(".search-results-container").innerHTML = "";
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }

  _show_search() {
    let glnav = document.querySelector(".glnav");
    let search_container = document.querySelector(".search-container");
    search_container.classList.add("focused");
    glnav.classList.add("focused");
  }

  _hide_search() {
    // remove focus
    var elements = document.querySelectorAll(".focused");
    Array.prototype.forEach.call(elements, function(el, i){
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
