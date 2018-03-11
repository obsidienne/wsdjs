import timeago from 'timeago.js';
import autolinkjs from 'autolink-js';
import MainView from '../main';
import Mustache from 'micromustache';

export default class View extends MainView {
  constructor() {
    super();
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".comment__delete")) {
        this._delete_comment(e.target);
        e.stopPropagation();
      }

      if (e.target && e.target.matches(".video__delete")) {
        this._delete_video(e.target);
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

    // autolinks in comments
    var els = document.querySelectorAll(".comment__content");
    for (var i = 0; i < els.length; i++) {
      els[i].innerHTML = els[i].innerHTML.autoLink();
    }
  }

  _headers() {
    var token = document.querySelector("[name=channel_token]").getAttribute("content");

    return new Headers({
      "Authorization": `Bearer ${token}`,
      "Accept": "application/json"
    });
  }

  _delete_comment(el) {
    if (!window.confirm("Are you sure to delete this comment ?")) {
      return;
    }

    fetch(el.dataset.path, {
      method: "DELETE",
      headers: this._headers()
    }).then((response) => {
      if (response.ok) {
        let comment = el.closest("li");
        comment.parentNode.removeChild(comment);
      } else {
        console.log('Mauvaise réponse du réseau');
      }
    }).catch(function(error) {
      console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
    });
  }

  _delete_video(el) {
    if (!window.confirm("Are you sure to delete this video ?")) {
      return;
    }

    fetch(el.dataset.path, {
      method: "DELETE",
      headers: this._headers()
    }).then((response) => {
      if (response.ok) {
        let video = el.closest("article");
        video.parentNode.removeChild(video);
      } else {
        console.log('Mauvaise réponse du réseau');
      }
    }).catch(function(error) {
      console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
    });
  }


  _submit(form) {
    if (form === undefined) return;

    fetch(form.action, {
      "method": form.method,
      "headers": this._headers(),
      "body": new FormData(form)
    }).then((response) => {
      if (response.ok) {
        form.reset();
        return response.json();
      } else {
        console.log('Mauvaise réponse du réseau');
      }
    }).then((payload) => {
      var container = document.getElementById("comments-container");
      var template = document.getElementById("comment-tpl").innerHTML;

      var tpl = Mustache.render(template, payload.data);

      container.insertAdjacentHTML('beforeend', tpl.autoLink());
    }).catch(function(error) {
      console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
      form.reset();
    });
  }

  _submit_video(form) {
    if (form === undefined) return;

    fetch(form.action, {
      "method": form.method,
      "headers": this._headers(),
      "body": new FormData(form)
    }).then((response) => {
      if (response.ok) {
        form.reset();
        return response.json();
      } else {
        console.log('Mauvaise réponse du réseau');
      }
    }).then((payload) => {
      let container = document.getElementById("overview-video");
      let template = document.getElementById("video-tpl").innerHTML;
      let tpl = Mustache.render(template, payload.data);
      container.insertAdjacentHTML('beforeend', tpl);
    }).catch(function(error) {
      console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
      form.reset();
    });
  }
}
