import timeago from 'timeago.js';
import autolinkjs from 'autolink-js';
import Tippy from 'tippy.js/dist/tippy';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class View {
  constructor() {
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".SongShowView .song-opinion")) {
        this._toggle_opinion(e.target);
        e.preventDefault();
      }
    }, false);

    document.addEventListener("submit", e => {
      if (e.target && e.target.matches("#song-comment-form")) {
        this._submit(e.target);
        e.preventDefault();
      }
    }, false);
  }

  mount() {
    new timeago().render(document.querySelectorAll("time.timeago"));
    this._submit();
    this.tips = new Tippy(".tippy[title]", {performance: true, size: "small", position: "top", appendTo: document.body});

    // autolinks in comments
    var els = document.querySelectorAll(".comment-content");
    for (var i = 0; i < els.length; i++) {
      els[i].innerHTML = els[i].innerHTML.autoLink();
    }

    var cl = cloudinary.Cloudinary.new();
    cl.init();
    cl.responsive();
  }
  unmount() { 
    this.tips.destroyAll();
  }

  _submit(form) {
    if (form === undefined) return;
    var self = this;

    var token = document.querySelector("[name=channel_token]").getAttribute("content");
    var request = new XMLHttpRequest();
    request.open(form.method, form.action, true);
    request.setRequestHeader('Authorization', "Bearer " + token);
    request.setRequestHeader('Accept', 'application/json');

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var container = document.querySelector(".container-comments ul");
        var tpl = self._createHtmlContent(JSON.parse(this.response).data);
        container.insertAdjacentHTML('beforeend', tpl);
        new timeago().render(document.querySelectorAll("time.timeago"));

        var cl = cloudinary.Cloudinary.new();
        cl.init();
        cl.responsive();
      } else {
        console.error("Error");
      }
    };

    request.onerror = function() { console.error("Error"); };
    request.send(new FormData(form));
  }

  _createHtmlContent(params) {
    return `
    <li class="comment">
      <div class="comment-avatar">
        <img src="${params.commented_by_avatar}" data-src="${params.commented_by_avatar}"  class="img-comment cld-responsive">
      </div>

      <div class="comment-box">
        <header class="comment-head">
          <a class="comment-author" href="${params.commented_by_path}">${params.commented_by}</a>
          <time class="timeago" title="${params.commented_at}" datetime="${params.commented_at}">${params.commented_at}</time>
        </header>
        <div class="comment-content">${params.text}</div>
      </div>
    </li>`;
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

    var cl = cloudinary.Cloudinary.new();
    cl.init();
    cl.responsive();
  }

  _refresh_kind(container, kind, data, user_opinion) {
    container.innerText = data.count;
    container.dataset.method = data.method;
    container.dataset.url = data.url;
    container.classList.remove("active")

    if (user_opinion == kind) {
      container.classList.add("active")
    }

    var tmp = container.closest("tr");
    var users = "";
    for (let i = 0; i < data.users.length && i < 8; i++) {
      users += `<a href="${data.users[i].url}"><img class="img-circle cld-responsive avatar-tiny tippy" data-size="small" src="//res.cloudinary.com/don2kwaju/image/upload/wsdjs/missing_avatar.jpg" data-src="${data.users[i].avatar}" title="${data.users[i].name}"></a>`;
    }
    tmp.querySelector("td").innerHTML = users;
  }  
}
