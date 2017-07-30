import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';
import Places from 'places.js/dist/cdn/places.js';

export default class View {
  constructor() {
    var self = this;

    var timeout;
    window.addEventListener("scroll", function(e) {
      if (document.querySelector("#user-profile-container")) {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
          var ticking = false;
          if (!ticking) {
            window.requestAnimationFrame(function() {
              self._refresh();
              ticking = false;
            });
          }
          ticking = true;
        }, 100);
      }      
    })
  }

  mount() {
    var numberFormat = new Intl.NumberFormat();

    var els = document.querySelectorAll(".number");
    for (let i = 0; i < els.length; i++) {
      els[i].textContent = numberFormat.format(els[i].textContent);
    }

    // intl date
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);
    var elements = document.querySelectorAll("time");
    for (let i = 0; i < elements.length; i++) {
      let datetime = Date.parse(elements[i].getAttribute("datetime"))
      elements[i].textContent = dateTimeFormat.format(datetime);
    }

    var cl = cloudinary.Cloudinary.new();
    cl.init();
    cl.responsive();
  }

  unmount() {}

  _refresh() {
    // stop there if we are not in the song index page
    var body = document.querySelector("body")
    if (! body.classList.contains("UserShowView"))
      return;
  
    var pageHeight = document.documentElement.scrollHeight;
    var clientHeight = document.documentElement.clientHeight;
    var scrollPos = window.pageYOffset;

    if (pageHeight - (scrollPos + clientHeight) < 50) {   
      var container = document.getElementById("song-list");
      var page_number = parseInt(container.dataset.jsPageNumber);
      var page_total = parseInt(container.dataset.jsTotalPages);
      var user_id = container.getAttribute("user-id");
        
      if (page_number < page_total) {
        this._retrieve_songs(user_id, page_number + 1);
      }      
    }
  }

  _retrieve_songs(user_id, page) {
    var request = new XMLHttpRequest();
    request.open('GET', `/songs?user_id=${user_id}&page=${page}`, true);
  
    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var total_pages = request.getResponseHeader("total-pages");
        var page_number = request.getResponseHeader("page-number");

        var container = document.getElementById("song-list");

        container.dataset.jsPageNumber = page_number;
        container.dataset.jsTotalPages = total_pages;
        container.insertAdjacentHTML('beforeend', this.response);

        var cl = cloudinaryCore.Cloudinary.new();
        cl.init();
        cl.responsive();
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }

}
