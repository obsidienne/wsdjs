import MainView from '../main';
import Tippy from 'tippy.js/dist/tippy';
import MyCloudinary from '../../components/my-cloudinary';

export default class View extends MainView {
  constructor() {
    super();
    
    var self = this;
    var timeout;
    window.addEventListener("scroll", function(e) {
      if (document.querySelector("#top-list")) {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
          self._fetch();
        }, 100);
      }      
    })
  }

  mount() { 
    super.mount();

    // tooltip
    this.tips = new Tippy(".tippy[title]", {performance: true, size: "small", position: "top", appendTo: document.body});
    this._intlTopDate();
  }

  unmount() {
    super.umount();
    this.tips.destroyAll();
  }

  _intlTopDate() {
    // intl date
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);
    var elements = document.querySelectorAll("time");
    for (let i = 0; i < elements.length; i++) {
      let datetime = Date.parse(elements[i].getAttribute("datetime"))
      elements[i].textContent = dateTimeFormat.format(datetime);
    }
  }

  _fetch() {
    var pageHeight = document.documentElement.scrollHeight;
    var clientHeight = document.documentElement.clientHeight;
    var scrollPos = window.pageYOffset;

    if (pageHeight - (scrollPos + clientHeight) < 50) {
      var container = document.getElementById("top-list");
      var page_number = parseInt(container.dataset.jsPageNumber);
      var page_total = parseInt(container.dataset.jsTotalPages);

      if (page_number < page_total) {
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
    
            MyCloudinary.refresh();
            self._intlTopDate();
          }
        };
    
        request.onerror = function() { console.log("Error search"); };
    
        request.send();    
      }
    }
  }
}