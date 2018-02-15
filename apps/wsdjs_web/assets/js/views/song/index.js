import timeago from 'timeago.js';
import MainView from '../main';
import lazyload from '../../components/lazyload';

export default class View extends MainView {
  constructor() {
    super();
    var self = this;

    var timeout;
    window.addEventListener("scroll", function(e) {
      clearTimeout(timeout);
      timeout = setTimeout(function() {
        if (self._needToFetchSongs()) {
          var sentinel = document.querySelector("#song-list section:last-child .sentinel");        
          self._fetchSongs(sentinel);
        }
      }, 100);
    })

    lazyload.refresh();
  }

  mount() {
    super.mount();

    if (this._needToFetchSongs()) {
      var sentinel = document.querySelector("#song-list section:last-child .sentinel");
      this._fetchSongs(sentinel);
    }
  }

  unmount() {
    super.umount();
  }
 
  _formatDate() {
    super.formatDate("time.date-format", {year: "numeric", month: "long"});
  }

  _needToFetchSongs() {
    var correctPage = document.querySelector(".SongIndexView");          
    var sentinel = document.querySelector("#song-list section:last-child .sentinel");

    if (!sentinel) return false;

    var rect = sentinel.getBoundingClientRect();
    return (
      rect.top >= 0 &&
      rect.left >= 0 &&
      rect.bottom <= (window.innerHeight || document. documentElement.clientHeight) &&
      rect.right <= (window.innerWidth || document. documentElement.clientWidth) &&
      correctPage
    );
  }

  _fetchSongs(sentinel) {
    var self = this;
    var request = new XMLHttpRequest();
    request.open('GET', `/songs?month=${sentinel.dataset.nextMonth}`, true);

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var container = document.getElementById("song-list");

        sentinel.parentNode.removeChild(sentinel);    
        container.insertAdjacentHTML('beforeend', this.response);
        
        if (self._needToFetchSongs()) {
          let sentinel = document.querySelector("#song-list section:last-child .sentinel");
          self._fetchSongs(sentinel);
        }

        new timeago().render(document.querySelectorAll("time.timeago"));
        self._formatDate();
        lazyload.refresh();
       }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }
}