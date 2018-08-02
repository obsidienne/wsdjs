import Tippy from 'tippy.js/dist/tippy.all';

class PlaylistPicker {
  constructor() {
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".song-picker-playlist")) {
        e.preventDefault();
        e.stopPropagation();
        this._addToPlaylist(e.target);
      }
    }, false);
  }

  mount() {
    console.log("mounting playlist picker...");
    if (document.getElementById("playlist-picker-tpl")) {
      this.tip = this.playlistPickerMount();
    }
  }

  unmount() {
    console.log("unmounting playlist picker...");
    if (this.tip) {
      this.tip.destroyAll();
    }
  }

  remount() {
    this.unmount();
    this.mount();
  }

  playlistPickerMount() {
    let tip = new Tippy(".playlist-picker", {
      animation: 'shift-away',
      arrow: false,
      html: '#playlist-picker-tpl',
      performance: true,
      interactive: true,
      trigger: 'click',
      theme: "playlist-picker",
      placement: "top-end",
      onShow: (instance) => {
        this.ref = instance.reference;
        this.poper = instance.popper;
      },
      onHide: () => {
        this.ref = undefined;
        this.poper = undefined;
      }
    });

    return tip;
  }

  _addToPlaylist(el) {
    // change the button value
    this._updatePickerRef(el);

    // hide the picker
    this.ref._tippy.hide();
  }


  _updatePickerRef(el) {
    const id = this.ref.closest(".hot-songs__song").dataset.id;
    const token = document.querySelector("[name=channel_token]").getAttribute("content");

}
}

export default new PlaylistPicker();