import Tippy from 'tippy.js/dist/tippy.all';

class PlaylistPicker {
  constructor() {
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".song-picker-playlist")) {
        e.preventDefault();
        e.stopPropagation();
        let playlistId = e.target.dataset.id;
        let songId = this.ref.closest(".hot-songs__song").dataset.id;
        this._addToPlaylist(playlistId, songId);
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
      theme: "playlist-picker",
      placement: "top-end",
      onShow: (instance) => {
        this.ref = instance.reference;
      },
      onHide: () => {
        this.ref = undefined;
      }
    });
    return tip;
  }

  _addToPlaylist(playlistId, songId) {
    const token = document.querySelector("[name=channel_token]").getAttribute("content");

    fetch(`/api/v1/playlists/${playlistId}/songs`, {
        body: JSON.stringify({
          song_id: songId
        }),
        cache: 'no-cache',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Accept': 'application/json',
          'content-type': 'application/json'
        },
        method: 'POST',
      })
      .then((response) => {
        if (response.ok) {
          console.log('Song added to the playlist');
        } else {
          console.log('Cannot add the song to the playlist.');
        }
      })
  }
}

export default new PlaylistPicker();