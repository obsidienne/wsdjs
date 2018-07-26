import Tippy from 'tippy.js/dist/tippy.all';
import Mustache from 'micromustache';

class OpinionPicker {
  constructor() {

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
      }
    });

    tip.loading = false;
    return tip;
  }
}

export default new OpinionPicker();