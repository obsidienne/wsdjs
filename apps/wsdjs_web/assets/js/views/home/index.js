import timeago from 'timeago.js';
import Tippy from 'tippy.js/dist/tippy.standalone';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class View {
  constructor() {
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".HomeIndexView .song-opinion")) {
        this._toggle_opinion(e.target);
        e.preventDefault();
      }
    });
  }

  mount() {
    // cloudinary
    var cl = cloudinary.Cloudinary.new();
    cl.init();
    cl.responsive();

    // intl date
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);
    var elements = document.querySelectorAll("time");
    for (let i = 0; i < elements.length; i++) {
      let datetime = Date.parse(elements[i].getAttribute("datetime"))
      elements[i].textContent = dateTimeFormat.format(datetime);
    }
    
    // tooltip
    console.log(this.tip);
    if (this.tip != undefined) this.tip.destroyAll();
    this.tip = new Tippy(".HomeIndexView .tippy", {performance: true, size: "small", position: "top"});
  }

  _toggle_opinion(elem) {
    var self = this;
    console.log("toggle opinion")

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
        self.tip.destroyAll();
        self._refresh_layout(container, JSON.parse(this.response));
        self.tip = new Tippy(".HomeIndexView .tippy", {performance: true, size: "small", position: "top"});
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
   
    container.setAttribute("title", users);
  }
}
