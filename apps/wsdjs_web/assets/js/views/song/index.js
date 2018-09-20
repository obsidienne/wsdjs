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

    document.addEventListener("click", e => {
      if (e.target && this.isOutside(e) && this.drawerIsOpen()) {
        this.hide();
      }
      if (e.target && e.target.closest("[data-js-drawer]")) {
        this.show();
      }
    }, false);

    document.addEventListener("submit", e => {
      if (e.target && e.target.matches("#facets-form")) {
        e.preventDefault();
        e.stopPropagation();
        this.search();
        return false;
      }
    })


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

  isOutside(e) {
    return e.target.matches(".facets-container.open");
  }

  drawerIsOpen() {
    return document.querySelector(".facets-container.open");
  }

  show() {
    let d = document.querySelector(".facets-container");
    if (d) {
      d.classList.add("open");
    }
  }

  hide() {
    let d = document.querySelector(".facets-container.open");
    if (d) {
      d.classList.remove("open");
    }
  }

  search() {
    opinionPicker.unmount();
    playlistPicker.unmount();

    const container = document.getElementById("song-list");
    container.innerHTML = '<div class="sentinel text-centered m-all-2"><div class="donut"></div></div>';

    var sentinel = document.querySelector("#song-list .sentinel");
    this.observer.observe(sentinel);
    this.hide();
  }

  fetchSongs(sentinel) {
    let form = document.getElementById('facets-form')
    let facets = window.formToObject(form);

    if (sentinel.dataset.query) {
      facets["month"] = sentinel.dataset.query;
    }

    this.channel.push("song", facets)
  }

  // song width = vw/2 - .25rem or 216px
  // song height = width + 146px
  insertFetchedSongs(payload) {
    // remove sentinel
    let sentinel = document.querySelector("#song-list .sentinel");
    sentinel.parentNode.removeChild(sentinel);

    const container = document.getElementById("song-list");
    container.insertAdjacentHTML('beforeend', payload.tpl);

    sentinel = document.querySelector("#song-list .sentinel");
    if (sentinel) {
      this.observer.observe(sentinel);
    }
    lazyload.refresh();
    opinionPicker.remount();
    playlistPicker.remount();
  }
}