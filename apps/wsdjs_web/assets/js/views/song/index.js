import MainView from '../main';
import lazyload from '../../components/lazyload';
import opinionPicker from '../../components/opinionPicker';
import playlistPicker from '../../components/playlistPicker';

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
    let q = document.getElementById('search-input').value;
    let month = sentinel.dataset.nextMonth;

    let facets = {
      month: month
    }
    if (q !== "") {
      facets["q"] = q;
    }

    let queryString = Object.keys(facets).map(k => `${encodeURIComponent(k)}=${encodeURIComponent(facets[k])}`).join('&');

    this.doFetchSongs(sentinel, queryString);
  }

  doFetchSongs(sentinel, queryString) {
    var container = document.getElementById("song-list");
    var page_number = parseInt(sentinel.dataset.jsPageNumber);

    fetch(`/songs?${queryString}`, {
        credentials: 'include',
        headers: {
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then((response) => {
        if (response.ok) {
          return response.text();
        } else {
          console.log('Mauvaise réponse du réseau');
        }
      })
      .then((data) => {
        var sentinel = document.querySelector("#song-list .sentinel");
        sentinel.parentNode.removeChild(sentinel);

        container.insertAdjacentHTML('beforeend', data);

        var sentinel = document.querySelector("#song-list .sentinel");
        this.observer.observe(sentinel);
        lazyload.refresh();
        opinionPicker.remount();
        playlistPicker.remount();
      })
      .catch(function (error) {
        console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
      });
  }
}