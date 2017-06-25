import timeago from 'timeago.js';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class search {
  mount() {
    var self = this;

    document.querySelector(".search-container").addEventListener('click', function(e) {
      self._show_search()
    });

    var debounce = JD.debounce(function() { self._search(); }, 50);
    document.getElementById("search-input").addEventListener('keyup', debounce);

    document.addEventListener("click", function(event) {
       if (event.target.closest('.search-container') == null) {
         self._hide_search();
       }
    });
  }

  _search(cl) {
    var query = document.getElementById("search-input").value;

    var request = new XMLHttpRequest();
    request.open('GET', '/search?q='+query, true);

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        document.querySelector(".search-results-container").innerHTML = this.response;
        new timeago().render(document.querySelectorAll(".search-results-container time.timeago"));
        var cl = cloudinary.Cloudinary.new();
        cl.init();
        cl.responsive();
      } else {
        document.querySelector(".search-results-container").innerHTML = "";
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }

  _show_search() {
    let glheader = document.querySelector(".glheader");
    let search_container = document.querySelector(".search-container");
    search_container.classList.add("focused");
    glheader.classList.add("focused");
  }

  _hide_search() {
    // remove focus
    var elements = document.querySelectorAll(".focused");
    Array.prototype.forEach.call(elements, function(el, i){
      el.classList.remove("focused");
    });

    // remove data from the result list
    document.querySelector(".search-results-container").innerHTML = "";

    // remove searched string
    document.getElementById("search-input").value = "";
  }
}
