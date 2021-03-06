import Tippy from 'tippy.js';

class PlaylistPicker {
  constructor() {
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".song-picker-playlist")) {
        e.preventDefault();
        e.stopPropagation();
        let playlistId = e.target.dataset.id;
        let songId = this._getSongId(this.ref);
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
      content: document.querySelector('#playlist-picker-tpl').innerHTML,
      performance: true,
      interactive: true,
      theme: "playlist-picker",
      placement: "top-end",
      onShow: (instance) => {
        this.ref = instance.reference;
        return true;
      },
      onHide: () => {
        this.ref = undefined;
        return true;
      }
    });
    return tip;
  }

  _getSongId(el) {
    let songCard = el.closest(".hot-songs__song");
    if (songCard) {
      return songCard.dataset.id;
    } else {
      return el.dataset.songId;
    }
  }

  _addToPlaylist(playlistId, songId) {
    console.log(`Add to playlist ${playlistId}, the song ${songId}`);
    const token = document.querySelector("[name=channel_token]").getAttribute("content");

    fetch(`${window.baseApiUrl}/playlists/${playlistId}/songs`, {
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
      .finally(e => {
        this.ref._tippy.hide();
      })
  }
}

export default new PlaylistPicker();