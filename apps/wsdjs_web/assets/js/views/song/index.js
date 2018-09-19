import MainView from '../main';
import lazyload from '../../components/lazyload';
import opinionPicker from '../../components/opinionPicker';
import playlistPicker from '../../components/playlistPicker';
import socket from "../../socket"

export default class View extends MainView {
  constructor() {
    super();

    this.observer = new IntersectionObserver((entries) => {
      for (var i = 0; i < entries.length; i++) {
        if (entries[i].isIntersecting) {
          let sentinel = entries[i].target;
          this.observer.unobserve(sentinel);
          this.fetchSongs(sentinel);
        }
      }
    });

    var sentinel = document.querySelector("#song-list .sentinel");
    this.observer.observe(sentinel);

    lazyload.refresh();

    this.channel = socket.channel("scrolling:song", {})
    this.channel.join()
      .receive("ok", resp => {
        console.log("Scrolling stream successfully joined", resp)
      })
      .receive("error", resp => {
        console.log("Unable to join the scrolling stream", resp)
      })

    this.channel.on("song", payload => {
      this.insertFetchedSongs(payload);
    });

  }

  mount() {
    super.mount();
    opinionPicker.mount();
  }

  unmount() {
    super.umount();
    opinionPicker.unmount();
  }

  fetchSongs(sentinel) {
    let month = sentinel.dataset.nextMonth;

    let facets = {
      month: month
    }

    this.channel.push("song", facets)
  }

  // song width = vw/2 - .25rem or 216px
  // song height = width + 146px
  insertFetchedSongs(payload) {
    // remove sentinel
    var sentinel = document.querySelector("#song-list .sentinel");
    sentinel.parentNode.removeChild(sentinel);

    var container = document.getElementById("song-list");
    container.insertAdjacentHTML('beforeend', payload.tpl);

    var sentinel = document.querySelector("#song-list .sentinel");
    this.observer.observe(sentinel);
    lazyload.refresh();
    opinionPicker.remount();
    playlistPicker.remount();
  }
}