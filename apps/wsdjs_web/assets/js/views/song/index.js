import MainView from '../main';
import lazyload from '../../components/lazyload';

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

  fetchSongs(sentinel) {
    var container = document.getElementById("song-list");
    var page_number = parseInt(sentinel.dataset.jsPageNumber);

    fetch(`/songs?month=${sentinel.dataset.nextMonth}`, {
        credentials: 'include'
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
      })
      .catch(function (error) {
        console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
      });
  }
}