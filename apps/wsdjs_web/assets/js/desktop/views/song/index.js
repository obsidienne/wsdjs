import timeago from 'timeago.js';
import Tippy from 'tippy.js/dist/tippy.all';
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
          var sentinel = document.querySelector("#song-list section:last-child .sentinel");        
          self._fetchSongs(sentinel);
        }
      }, 100);
    })

    document.addEventListener("click", function(e) {
      if (e.target && e.target.matches(".SongIndexView .song-opinion")) {
        self._toggle_opinion(e.target);
        e.preventDefault();
        e.stopPropagation();
      }

    }, false);
  }

  mount() {
    super.mount();

    if (this._needToFetchSongs()) {
      var sentinel = document.querySelector("#song-list section:last-child .sentinel");
      this._fetchSongs(sentinel);
    }

    // tooltip
    this.tips = new Tippy(".tippy[title]", {performance: true});
  }

  unmount() {
    super.umount();
    this.tips.destroyAll();
  }
 
  _formatDate() {
    super.formatDate("time.date-format", {year: "numeric", month: "long"});
  }

  _toggle_opinion(elem) {
    var self = this;

    var container = elem.closest(".song-opinions");
    var method = elem.dataset.method;
    var url = elem.dataset.url;
    var token = document.querySelector("[name=channel_token]").getAttribute("content");

    var request = new XMLHttpRequest();
    request.open(method, url, true);
    request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
    request.setRequestHeader('Authorization', "Bearer " + token);
    request.setRequestHeader('Accept', 'application/json');

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        self.tips.destroyAll();
        self._refresh_layout(container, JSON.parse(this.response));
        self.tips = new Tippy(".tippy[title]", {performance: true});
      } else {
        console.error("Error");
      }
    };

    request.onerror = function() { console.error("Error"); };
    request.send();
  }

  _refresh_layout(container, data) {
    var song_up = container.querySelector(".song-up");
    var song_like = container.querySelector(".song-like");
    var song_down = container.querySelector(".song-down");

    this._refresh_kind(song_up, "up", data.data.up, data.data.user_opinion);
    this._refresh_kind(song_like, "like", data.data.like, data.data.user_opinion);
    this._refresh_kind(song_down, "down", data.data.down, data.data.user_opinion);
  }

  _refresh_kind(container, kind, data, user_opinion) {
    container.innerText = data.count;
    container.dataset.method = data.method;
    container.dataset.url = data.url;
    container.classList.remove("active")
    container.removeAttribute("title");

    if (user_opinion == kind) {
      container.classList.add("active")
    }
    var users = "";
    for (let i = 0; i < data.users.length && i < 8; i++) {
      users += data.users[i].name;
      if (i <= data.users.length - 1 || i == 8) {
        users += "<br />";
      }
    }

    if (users != "") {
      container.setAttribute("title", users);
    }
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
        self.tips.destroyAll();
        self._formatDate();
        self.tips = new Tippy(".tippy[title]", {performance: true});
       }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }
}