import MainView from '../main';
import lazyload from '../../components/lazyload';
import Tippy from 'tippy.js/dist/tippy.all';

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
    this.tip = this.opinionTooltipMount();
  }

  unmount() {
    super.umount();
    this.tip.destroyAll();
  }

  opinionTooltipMount() {
    let tip = new Tippy("#song-list", {
      animation: 'shift-away',
      arrow: false,
      html: '#opinion-selector-tpl',
      performance: true,
      interactive: true,
      theme: "wsdjs",
      placement: "top-start",
      interactiveBorder: 2,
      target: ".opinion-tippy",
      appendTo: document.getElementsByTagName("main")[0],
      onHidden: (instance) => {
        const content = instance.popper.querySelector('.tippy-content');
        content.innerHTML = "loading...";
      },
      onShow: (instance) => {
        const content = instance.popper.querySelector('.tippy-content');

        if (this.tip.loading || content.innerHTML !== "loading...") return;
        this.tip.loading = true;

        let songId = instance.reference.closest("li").dataset.id;

        fetch(`/songs/${songId}/opinions`, {
            credentials: 'include',
            headers: {
              'X-Requested-With': 'XMLHttpRequest'
            }
          })
          .then((response) => {
            if (response.ok) {
              return response.text();
            } else {
              this.tip.loading = false;
              console.log('Loading failed');
            }
          })
          .then((data) => {
            content.innerHTML = data;
            this.tip.loading = false;
          })
          .catch(e => {
            content.innerHTML = 'Loading failed';
            this.tip.loading = false;
          })
      }
    });

    tip.loading = false;
    return tip;
  }

  fetchSongs(sentinel) {
    var container = document.getElementById("song-list");
    var page_number = parseInt(sentinel.dataset.jsPageNumber);

    fetch(`/songs?month=${sentinel.dataset.nextMonth}`, {
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
      })
      .catch(function (error) {
        console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
      });
  }
}