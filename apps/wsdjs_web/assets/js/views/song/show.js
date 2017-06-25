import timeago from 'timeago.js';
import autolinkjs from 'autolink-js';
import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    new timeago().render(document.querySelectorAll("time.timeago"));
    this._intlDate();
    this._submit();
    // Specific logic here
    console.log('SongShowView mounted');
  }

  _intlDate() {
    var elements = document.querySelectorAll(".comment-content");

    Array.prototype.forEach.call(elements, function(el, i) {
        el.innerHTML = el.innerHTML.autoLink();
    });
  }

  _submit() {
    var self = this;
    var form = document.querySelector('#song-comment-form');
    form.addEventListener('submit', function(e) {
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
        } else {
          console.error("Error");
        }
      };

      request.onerror = function() { console.error("Error"); };
      request.send(new FormData(form));

      e.preventDefault();
      return false;
    })
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
    </li>`
  }
}
