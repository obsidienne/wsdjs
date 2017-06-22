import timeago from 'timeago.js';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class search {
  mount() {
    var self = this;
    var timer;
    document.querySelector(".glsearch").addEventListener('click', function(e) {
      self._show_search()
    });

    document.getElementById("glsearch").addEventListener('keyup', function() {
      clearTimeout(timer);  //clear any running timeout on key up
      timer = setTimeout(function() { //then give it a second to see if the user is finished
        self._search();
      }, 500);
    });

    document.addEventListener("click", function(event) {
       if (event.target.closest('.glsearch') == null) {
         self._hide_search();
       }
    });
  }

  _search(cl) {
    var query = document.getElementById("glsearch").value;

    var request = new XMLHttpRequest();
    request.open('GET', '/search?q='+query, true);

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        document.querySelector(".glsearch__results").innerHTML = this.response;
        new timeago().render(document.querySelectorAll(".glsearch__results time.timeago"));
        var cl = cloudinary.Cloudinary.new();
        cl.init();
        cl.responsive();
      } else {
        document.querySelector(".glsearch__results").innerHTML = "";
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }

  _show_search() {
    let search_results = document.querySelector(".glsearch__results");
    let glsearch = document.querySelector(".glsearch");

    glsearch.classList.add("glsearch--focused");
    search_results.classList.add("glsearch--focused");
  }

  _hide_search() {
    // remove focus
    var elements = document.querySelectorAll(".glsearch--focused");
    Array.prototype.forEach.call(elements, function(el, i){
      el.classList.remove("glsearch--focused");
    });

    // remove data from the result list
    document.querySelector(".glsearch__results").innerHTML = "";

    // remove searched string
    document.getElementById("glsearch").value = "";
  }
}
