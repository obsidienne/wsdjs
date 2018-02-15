import timeago from 'timeago.js';
import autolinkjs from 'autolink-js';
import Tippy from 'tippy.js/dist/tippy.all';
import MainView from '../main';

export default class View extends MainView {
  constructor() {
    super();
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".SongShowView .song-opinion")) {
        this._toggle_opinion(e.target);
        e.preventDefault();
        e.stopPropagation();
      }

      if (e.target && e.target.matches(".comment__delete")) {
        this._delete_comment(e.target);
        e.stopPropagation();
      }
    }, false);

    document.addEventListener("submit", e => {
      if (e.target && e.target.matches("#song-comment-form")) {
        this._submit(e.target);
        e.preventDefault();
      }

      if (e.target && e.target.matches("#song-video-form")) {
        this._submit_video(e.target);
        e.preventDefault();
      }
    }, false);
  }

  mount() {
    super.mount();
    this._submit();
    this.tips = new Tippy(".tippy[title]", {performance: true});

    // autolinks in comments
    var els = document.querySelectorAll(".comment__content");
    for (var i = 0; i < els.length; i++) {
      els[i].innerHTML = els[i].innerHTML.autoLink();
    }
  }
  unmount() { 
    super.umount();
    this.tips.destroyAll();
  }

  _delete_comment(el) {
    if (!window.confirm("Are you sure to delete this comment ?")) {
      return;
    }

    var token = document.querySelector("[name=channel_token]").getAttribute("content");
    var request = new XMLHttpRequest();
    request.open("DELETE", el.dataset.path, true);
    request.setRequestHeader('Authorization', "Bearer " + token);
    request.setRequestHeader('Accept', 'application/json');

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        let comment = el.closest("li");
        comment.parentNode.removeChild(comment);
      } else {
        console.error("Error");
      }
    };

    request.onerror = function() { console.error("Error"); };
    request.send();
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
        var container = document.getElementById("comments-container");
        var tpl = self._createHtmlContent(JSON.parse(this.response).data);
        container.insertAdjacentHTML('beforeend', tpl);
        new timeago().render(document.querySelectorAll("time.timeago"));
      } else {
        console.error("Error");
      }
    };

    request.onerror = function() { console.error("Error"); };
    request.send(new FormData(form));
    form.reset();
  }

  _submit_video(form) {
    if (form === undefined) return;
    var self = this;

    var token = document.querySelector("[name=channel_token]").getAttribute("content");
    var request = new XMLHttpRequest();
    request.open(form.method, form.action, true);
    request.setRequestHeader('Authorization', "Bearer " + token);
    request.setRequestHeader('Accept', 'application/json');

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var container = document.getElementById("videos-container");
        var tpl = self._createHtmlVideoContent(JSON.parse(this.response).data);
        container.insertAdjacentHTML('beforeend', tpl);
      } else {
        console.error("Error");
      }
    };

    request.onerror = function() { console.error("Error"); };
    request.send(new FormData(form));
    form.reset();
  }

  _createHtmlContent(params) {
    return `
    <li class="comment">
      <div class="comment__avatar">
        <img src="${params.user.avatars.avatar_uri}"  class="comment__avatar__img">
      </div>

      <div class="comment__body">
        <header class="comment__header">
          <span>
            <a href="${params.user.path}">${params.user.name}</a>
            <time class="timeago small" title="${params.commented_at}" datetime="${params.commented_at}"></time>
          </span>
          <button class="btn-link comment__delete" data-path="/api/v1/comments/${params.id}"></button>
        </header>
        <div class="comment__content">${params.text}</div>
      </div>
    </li>`;
  }

  _createHtmlVideoContent(params) {
    return `
    <li class="video">
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
    container.getElementsByTagName("span")[0].innerText = data.count;
    container.dataset.method = data.method;
    container.dataset.url = data.url;
    container.setAttribute("title", data.tooltip_html);
    container.classList.remove("active")

    if (user_opinion == kind) {
      container.classList.add("active")
    }
  }  
}
