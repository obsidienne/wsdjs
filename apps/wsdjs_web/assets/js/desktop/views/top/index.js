import MainView from '../main';
import Tippy from 'tippy.js/dist/tippy.all';

export default class View extends MainView {
  constructor() {
    super();
    
    var self = this;
    var timeout;
    window.addEventListener("scroll", function(e) {
      clearTimeout(timeout);
      timeout = setTimeout(function() {
        if (self._needToFetchTops()) {
          var sentinel = document.querySelector("#top-list .sentinel");
          self._fetchTops();
        }
      }, 100);
    })
  }

  mount() { 
    super.mount();
    this.tips = new Tippy(".tippy[title]", {performance: true});
  }

  unmount() {
    super.umount();
    this.tips.destroyAll();
  }

  _formatDate() {
    super.formatDate("time.date-format", {year: "numeric", month: "long"});
  }

  _needToFetchTops() {
    /* check the sentinel is in DOM */
    var correctPage = document.querySelector(".TopIndexView");
    var sentinel = document.querySelector("#top-list .sentinel");
    if (!sentinel) return false;
    
    /* check nb pages already fetched */
    var container = document.getElementById("top-list");
    var page_number = parseInt(container.dataset.jsPageNumber);
    var page_total = parseInt(container.dataset.jsTotalPages);
    if (page_number >= page_total) return false;
    
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

  _fetchTops() {
    var container = document.getElementById("top-list");    
    var page_number = parseInt(container.dataset.jsPageNumber);
    
    var self = this;
    var request = new XMLHttpRequest();
    request.open('GET', `/tops?page=${page_number + 1}`, true);

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var total_pages = request.getResponseHeader("total-pages");
        var page_number = request.getResponseHeader("page-number");

        container.dataset.jsPageNumber = page_number;
        container.dataset.jsTotalPages = total_pages;

        container.insertAdjacentHTML('beforeend', this.response);

        var sentinel = document.querySelector("#top-list .sentinel");
        sentinel.parentNode.removeChild(sentinel);    
        
        self._formatDate();
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();    
  }
}