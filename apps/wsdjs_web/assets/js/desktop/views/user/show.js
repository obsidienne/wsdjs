import Places from 'places.js/dist/cdn/places.js';
import MainView from '../main';

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
    super.mount();
  }

  _needToFetchSongs() {
    /* check nb pages already fetched */
    var container = document.getElementById("user-page__song-list");
    var page_number = parseInt(container.dataset.jsPageNumber);
    var page_total = parseInt(container.dataset.jsTotalPages);
    if (page_number >= page_total) return false;

    /* check the sentinel is in DOM */
    var correctPage = document.querySelector(".UserShowView");
    var sentinel = document.querySelector("#suggestions-section .sentinel");
    if (!sentinel) return false;
    
    /* check sentinel is in viewport*/
    var rect = sentinel.getBoundingClientRect();
    return (
      rect.top >= 0 &&
      rect.left >= 0 &&
      rect.bottom <= (window.innerHeight || document. documentElement.clientHeight) &&
      rect.right <= (window.innerWidth || document. documentElement.clientWidth) &&
      correctPage
    );
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

        if (total_pages == page_number) {
          var sentinel = document.querySelector("#suggestions-section .sentinel");
          sentinel.parentNode.removeChild(sentinel);  
        }
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }

}
