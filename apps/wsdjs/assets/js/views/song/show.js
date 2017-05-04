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
    console.log('SongIndexView mounted');
  }

  _intlDate() {
    var elements = document.querySelectorAll(".comment-content");

    Array.prototype.forEach.call(elements, function(el, i) {
        el.innerHTML = el.innerHTML.autoLink();
    });
  }

  _submit() {
    var form = document.querySelector('#song-comment-form');
    form.addEventListener('submit', function(e) {
      var token = document.querySelector("[name=channel_token]").getAttribute("content");

      var request = new XMLHttpRequest();
      request.open(form.method, form.action, true);
      request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
      request.setRequestHeader('Authorization', "Bearer " + token);
      request.setRequestHeader('Accept', 'application/json');

      request.onload = function() {
        if (this.status >= 200 && this.status < 400) {
          self.parentNode.innerHTML = this.response;
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
}
