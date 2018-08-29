import Tippy from 'tippy.js/dist/tippy.all';

class PlaylistPicker {
  constructor() {
    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".song-picker-playlist")) {
        e.preventDefault();
        e.stopPropagation();
        let playlistId = e.target.dataset.id;
        let songId = this.ref.closest(".hot-songs__song").dataset.id;
        console.log(songId)
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
        this.popper = instance.popper;
        this.savedContent = this.popper.querySelector('.tippy-content').innerHTML
        this._fetchPlaylists(instance);
      },
      onHide: () => {
        this.popper.querySelector('.tippy-content').innerHTML = this.savedContent;
        this.ref = undefined;
        this.popper = undefined;
      }
    });

    tip.loading = false;
    return tip;
  }

  _fetchPlaylists(instance) {
    const content = instance.popper.querySelector('.tippy-content');

    if (this.tip.loading || content.innerHTML !== this.savedContent) return;
    this.tip.loading = true;

    let userId = document.querySelector("main").dataset.userId;
    let token = document.querySelector("[name=channel_token]").getAttribute("content");

    fetch(`/api/v1/users/${userId}/playlists`, {
        headers: {
          "Authorization": `Bearer ${token}`,
          "Accept": "application/json"
        }
      })
      .then((response) => {
        if (response.ok) {
          return response.json();
        } else {
          console.log('Loading failed');
        }
      })
      .then((data) => {
        let l = "";
        data.data.forEach(e => {
          l += `<li>
                  <button class="bg-hover btn-no-style d-block p-y-1 p-x-2 w-100 text-left song-picker-playlist" data-id="${e.id}">${e.name}</button>
                </li>`
        });

        content.querySelector("ul").innerHTML = l;
      })
      .catch(e => {
        content.innerHTML = 'Loading failed';
      }).finally(e => {
        this.tip.loading = false;
      })
  }

  _addToPlaylist(playlistId, songId) {
    console.log(playlistId);
    console.log(songId);
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
          return response.json();
        } else {
          console.log('Loading failed');
        }
      })
  }
}

export default new PlaylistPicker();