import timeago from 'timeago.js';
import Tippy from 'tippy.js/dist/tippy';
import MainView from '../main';

export default class View extends MainView {
  constructor() {
    super();

    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".HomeIndexView .song-opinion")) {
        this._toggle_opinion(e.target);
        e.preventDefault();
        e.stopPropagation();
      }
    });
  }

  mount() {
    super.mount();
    this.tips = new Tippy(".tippy[title]", {performance: true, size: "small", position: "top", appendTo: document.body});
  }

  unmount() {
    super.umount();
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
    //get popper

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
}
