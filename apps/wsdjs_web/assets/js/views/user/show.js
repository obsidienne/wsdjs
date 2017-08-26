import Places from 'places.js/dist/cdn/places.js';
import MainView from '../main';
import MyCloudinary from '../../components/my-cloudinary';

export default class View extends MainView {
  constructor() {
    super();
    var self = this;

    var timeout;
    window.addEventListener("scroll", function(e) {
      clearTimeout(timeout);
      timeout = setTimeout(function() {
        if (self._needToFetchSongs()) {
          self._fetchSongs();
        }
      }, 100);
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
    super.mount();
  }

  _needToFetchSongs() {
    var correctPage = document.querySelector(".UserShowView");   
    if (!correctPage) return false;

    var pageHeight = document.documentElement.scrollHeight;
    var clientHeight = document.documentElement.clientHeight;
    var scrollPos = window.pageYOffset;
   

    var container = document.getElementById("user-page__song-list");    
    var page_number = parseInt(container.dataset.jsPageNumber);
    var page_total = parseInt(container.dataset.jsTotalPages);

    if (pageHeight - (scrollPos + clientHeight) < 50 && correctPage && page_number < page_total) {
      return true;
    }
    return false;
  }

  _fetchSongs() {
    var container = document.getElementById("user-page__song-list");    
    var user_id = container.getAttribute("user-id");
    var page = parseInt(container.dataset.jsPageNumber) + 1;    

    var request = new XMLHttpRequest();
    request.open('GET', `/songs?user_id=${user_id}&page=${page}`, true);
  
    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var total_pages = request.getResponseHeader("total-pages");
        var page_number = request.getResponseHeader("page-number");

        var container = document.getElementById("user-page__song-list");
        container.dataset.jsPageNumber = page_number;
        container.dataset.jsTotalPages = total_pages;
        container.insertAdjacentHTML('beforeend', this.response);

        MyCloudinary.refresh();
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }

}
