import MainView from '../main';
import Mustache from 'micromustache';

export default class View extends MainView {
  constructor() {
    super();
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".video__delete")) {
        this._delete_video(e.target);
        e.stopPropagation();
      }
    }, false);

    document.addEventListener("submit", e => {
      if (e.target && e.target.matches("#song-video-form")) {
        this._submit(e.target);
        e.preventDefault();
        e.stopPropagation();
      }
    }, false);
  }

  mount() {
    super.mount();
  }

  _headers() {
    var token = document.querySelector("[name=channel_token]").getAttribute("content");

    return new Headers({
      "Authorization": `Bearer ${token}`,
      "Accept": "application/json"
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
    }).catch(function (error) {
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
      let container = document.getElementById("overview-video");
      let template = document.getElementById("video-tpl").innerHTML;
      let tpl = Mustache.render(template, payload.data);
      container.insertAdjacentHTML('beforeend', tpl);
    }).catch(function (error) {
      console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
      form.reset();
    });
  }
}