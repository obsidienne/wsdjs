import Tippy from 'tippy.js/dist/tippy.all';
import Mustache from 'micromustache';

class OpinionPicker {
  constructor() {
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".song-picker-opinion")) {
        e.preventDefault();
        e.stopPropagation();
        this._toggleOpinion(e.target);
      }
    }, false);
  }

  mount() {
    console.log("mounting opinion picker...");
    if (document.getElementById("opinion-picker-tpl")) {
      this.tip = this.opinionPickerMount();
    }
  }

  unmount() {
    console.log("unmounting opinion picker...");
    if (this.tip) {
      this.tip.destroyAll();
    }
  }

  remount() {
    this.unmount();
    this.mount();
  }

  opinionPickerMount() {
    let tip = new Tippy(".opinion-picker", {
      animation: 'shift-away',
      arrow: false,
      html: '#opinion-picker-tpl',
      performance: true,
      interactive: true,
      theme: "wsdjs",
      placement: "top-start",
      interactiveBorder: 2,
      onShow: (instance) => {
        this.ref = instance.reference;
        const songId = instance.reference.closest(".hot-songs__song").dataset.id;
        const content = instance.popper.querySelector('.tippy-content');

        let tpl = Mustache.render(content.innerHTML, {
          down_method: "POST",
          down_url: "/api/v1/songs/${songId}/opinions?kind=down",
          like_method: "",
          like_url: "/api/v1/songs/${songId}/opinions?kind=like",
          top_method: "",
          top_url: "/api/v1/songs/${songId}/opinions?kind=top"
        });
        content.innerHTML = tpl;
      },
      onHide: () => {
        this.ref = undefined;
      }
    });

    tip.loading = false;
    return tip;
  }

  _toggleOpinion(el) {
    // change the button value
    this._updatePickerRef(el);

    // hide the picker
    this.ref._tippy.hide();
  }


  _updatePickerRef(el) {
    const none = "<svg fill='#455A64' height='24' viewBox='0 0 24 24' width='24'><path d='M0 0h24v24H0z' fill='none'/><path d='M16.5 3c-1.74 0-3.41.81-4.5 2.09C10.91 3.81 9.24 3 7.5 3 4.42 3 2 5.42 2 8.5c0 3.78 3.4 6.86 8.55 11.54L12 21.35l1.45-1.32C18.6 15.36 22 12.28 22 8.5 22 5.42 19.58 3 16.5 3zm-4.4 15.55l-.1.1-.1-.1C7.14 14.24 4 11.39 4 8.5 4 6.5 5.5 5 7.5 5c1.54 0 3.04.99 3.57 2.36h1.87C13.46 5.99 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5 0 2.89-3.14 5.74-7.9 10.05z'/></svg>";
    const down = "<svg fill='hsl(0, 100%, 35%)' height='24' viewBox='0 0 24 24' width='24'><path d='M0 0h24v24H0V0z' fill='none'/><path d='M20 12l-1.41-1.41L13 16.17V4h-2v12.17l-5.58-5.59L4 12l8 8 8-8z'/></svg>";
    const like = "<svg fill='hsl(240, 100%, 35%)' height='24' viewBox='0 0 24 24' width='24'><path d='M12,21.35L10.55,20.03C5.4,15.36 2,12.27 2,8.5C2,5.41 4.42,3 7.5,3C9.24,3 10.91,3.81 12,5.08C13.09,3.81 14.76,3 16.5,3C19.58,3 22,5.41 22,8.5C22,12.27 18.6,15.36 13.45,20.03L12,21.35Z' /></svg>";
    const up = "<svg fill='hsl(120, 100%, 35%)' height='24' viewBox='0 0 24 24' width='24'><path d='M0 0h24v24H0V0z' fill='none'/><path d='M4 12l1.41 1.41L11 7.83V20h2V7.83l5.58 5.59L20 12l-8-8-8 8z'/></svg>";

    const id = this.ref.closest(".hot-songs__song").dataset.id;
    const token = document.querySelector("[name=channel_token]").getAttribute("content");
    const prevValue = this.ref.dataset.opinion;
    const newValue = el.dataset.opinion;

    let method = "POST";
    let url = `/api/v1/songs/${id}/opinions?kind=${newValue}`;
    let trigger = this.ref;

    if (prevValue == newValue) {
      this.ref.dataset.opinion = "";
      this.ref.innerHTML = none;
      method = "DELETE";
      let opinionId = this.ref.closest("footer").dataset.opinionId;
      url = `/api/v1/opinions/${opinionId}`;
    } else {
      this.ref.dataset.opinion = newValue;

      switch (newValue) {
        case 'down':
          this.ref.innerHTML = down;
          break;
        case 'like':
          this.ref.innerHTML = like;
          break;
        case 'up':
          this.ref.innerHTML = up;
          break;
      }
    }

    // It should work so launch the request
    fetch(url, {
      method: method,
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
      trigger.dataset.opinionId = data.data.user_opinion_id;
    })
    .catch(function (error) {
      console.log('Loading failed, reason: ' + error.message);
    })
  }
}

export default new OpinionPicker();