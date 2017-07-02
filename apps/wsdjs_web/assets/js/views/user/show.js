import MainView from '../main';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class View extends MainView {
  mount() {
    super.mount();

    var self = this;

    var debounce = JD.debounce(function() { self._refresh(); }, 100);
    window.addEventListener('scroll', debounce);

    console.log('UserShowView mounted');
  }

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

        console.log(`${page_number} / ${total_pages}`);
        var container = document.getElementById("song-list");

        container.dataset.jsPageNumber = page_number;
        container.dataset.jsTotalPages = total_pages;
        container.insertAdjacentHTML('beforeend', this.response);

        var cl = cloudinary.Cloudinary.new();
        cl.init();
        cl.responsive();
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }
}
