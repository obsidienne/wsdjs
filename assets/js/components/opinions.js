
class Opinions {
  constructor() {
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".song-opinion")) {
        e.preventDefault();
        e.stopPropagation();
        this._toggle_opinion(e.target);
      }
    }, false);
  }

  mount() {
    console.log("mounting opinions tooltip...");
  }

  unmount() {
    console.log("unmounting opinions tooltip...");
    if (this.tip) {
      this.tip.destroyAll();
    }
  }

  _toggle_opinion(elem) {
    var token = document.querySelector("[name=channel_token]").getAttribute("content");

    fetch(elem.dataset.url, {
      method: elem.dataset.localMethod,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": `Bearer ${token}`
      }
    })
      .then((response) => {
        if (response.ok) {
          return response.json();
        } else {
          console.log('loading failed');
        }
      })
      .then((data) => {
        var container = elem.closest(".song-opinions") || (elem.closest && elem.closest(".tippy-content"));
        this._refresh_layout(container, data);
      })
      .catch(function (error) {
        console.log('Loading failed, reason: ' + error.message);
      })
      .finally(e => {

      })
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
    container.dataset.localMethod = data.method;
    container.dataset.url = data.url;
    if (data.tooltip_html) {
      container.dataset.tippyContent = data.tooltip_html;
      Tippy(container);

    } else {
      delete container.dataset.tippy;
      if (container._tippy) {
        container._tippy.destroy();
      }
    }
    container.classList.remove("active")

    if (user_opinion == kind) {
      container.classList.add("active")
    }
  }
}

export default new Opinions();