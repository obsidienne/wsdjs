import CloudinaryCore from 'cloudinary-core/cloudinary-core-shrinkwrap';
import timeago from 'timeago.js';
import Tippy from 'tippy.js/dist/tippy';

export default class View {
  constructor() {
    var self = this;

    var timeout;
    window.addEventListener("scroll", function(e) {
      if (document.querySelector("#song-list")) {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
          self._refresh();
        }, 100);
      }      
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
    // cloudinary
    var cl = CloudinaryCore.Cloudinary.new();
    cl.init();
    cl.responsive();

    // tooltip
    this.tips = new Tippy(".tippy[title]", {performance: true, size: "small", position: "top", appendTo: document.body});

    new timeago().render(document.querySelectorAll("time.timeago"));
  }

  unmount() { 
    this.tips.destroyAll();
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
        self.tips = new Tippy(".tippy[title]", {performance: true, size: "small", position: "top", appendTo: document.body});
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

  _refresh() {
    var pageHeight = document.documentElement.scrollHeight;
    var clientHeight = document.documentElement.clientHeight;
    var scrollPos = window.pageYOffset;

    if (pageHeight - (scrollPos + clientHeight) < 50) {
      var container = document.getElementById("song-list");
      var page_number = parseInt(container.dataset.jsPageNumber);
      var page_total = parseInt(container.dataset.jsTotalPages);

      if (page_number < page_total) {
        this._retrieve_songs(page_number + 1);
        new timeago().render(document.querySelectorAll("time.timeago"));
      }
    }
  }

  _retrieve_songs(page) {
    var self = this;
    var request = new XMLHttpRequest();
    request.open('GET', `/songs?page=${page}`, true);

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var total_pages = request.getResponseHeader("total-pages");
        var page_number = request.getResponseHeader("page-number");

        var container = document.getElementById("song-list");

        container.dataset.jsPageNumber = page_number;
        container.dataset.jsTotalPages = total_pages;

        container.insertAdjacentHTML('beforeend', this.response);

        var cl = CloudinaryCore.Cloudinary.new();
        cl.init();
        cl.responsive();
        new timeago().render(document.querySelectorAll("time.timeago"));
        self.tips.destroyAll();
        self.tips = new Tippy(".tippy[title]", {performance: true, size: "small", position: "top", appendTo: document.body});
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }
}