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
      animation: 'shift-toward',
      arrow: true,
      arrowType: 'round',
      html: '#opinion-selector-tpl',
      performance: true,
      target: ".opinion-tippy",
      onHidden: (instance) => {
        const content = instance.popper.querySelector('.tippy-content');
        content.innerHTML = "loading...";
      },
      onShow: (instance) => {
        const content = instance.popper.querySelector('.tippy-content');
        console.log(content.innerHTML)
        if (this.tip.loading || content.innerHTML !== "loading...") return;
        this.tip.loading = true;

        fetch('https://unsplash.it/200/?random').then(resp => resp.blob()).then(blob => {
          const url = URL.createObjectURL(blob);
          content.innerHTML = `<img width="200" height="200" src="${url}">`;
          this.tip.loading = false;
        }).catch(e => {
          content.innerHTML = 'Loading failed';
          this.tip.loading = false;
        })
      },
      // prevent tooltip from displaying over button
      popperOptions: {
        modifiers: {
          preventOverflow: {
            enabled: true
          },
          hide: {
            enabled: false
          }
        }
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