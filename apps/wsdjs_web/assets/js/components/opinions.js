import Tippy from 'tippy.js/dist/tippy.all';

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
    if (document.getElementById("opinion-selector-tpl")) {
      this.tip = this.opinionTooltipMount();
    }
  }

  unmount() {
    console.log("unmounting opinions tooltip...");
    if (this.tip) {
      this.tip.destroyAll();
    }
  }

  opinionTooltipMount() {
    let tip = new Tippy("main", {
      animation: 'shift-away',
      arrow: false,
      html: '#opinion-selector-tpl',
      performance: true,
      interactive: true,
      theme: "wsdjs",
      placement: "top-start",
      interactiveBorder: 2,
      target: ".opinion-tippy",
      appendTo: document.getElementsByTagName("main")[0],
      onHidden: (instance) => {
        const content = instance.popper.querySelector('.tippy-content');
        content.innerHTML = "loading...";
      },
      onShow: (instance) => {
        this._fetch_opinions(instance);
      }
    });

    tip.loading = false;
    return tip;
  }

  _fetch_opinions(instance) {
    const content = instance.popper.querySelector('.tippy-content');

    if (this.tip.loading || content.innerHTML !== "loading...") return;
    this.tip.loading = true;

    let songId = instance.reference.closest("li").dataset.id;

    fetch(`/songs/${songId}/opinions`, {
        credentials: 'include',
        headers: {
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then((response) => {
        if (response.ok) {
          return response.text();
        } else {
          console.log('Loading failed');
        }
      })
      .then((data) => {
        content.innerHTML = data;
      })
      .catch(e => {
        content.innerHTML = 'Loading failed';
      }).finally(e => {
        this.tip.loading = false;
      })
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
        this.tip.hide();
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
    container.setAttribute("title", data.tooltip_html);
    container.classList.remove("active")

    if (user_opinion == kind) {
      container.classList.add("active")
    }
  }
}

export default new Opinions();