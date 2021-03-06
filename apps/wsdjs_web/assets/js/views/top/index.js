import MainView from '../main';

export default class View extends MainView {
  constructor() {
    super();

    this.observer = new IntersectionObserver((entries) => {
      for (var i = 0; i < entries.length; i++) {
        if (entries[i].isIntersecting) {
          let sentinel = entries[i].target;
          this.observer.unobserve(sentinel);
          this.fetchTops(sentinel);
        }
      }
    });

    var sentinel = document.querySelector("#top-list .sentinel");
    if (sentinel !== null) {
      this.observer.observe(sentinel);
    }
  }

  fetchTops(sentinel) {
    var container = document.getElementById("top-list");
    var page_number = parseInt(sentinel.dataset.jsPageNumber);

    fetch(`/tops?page=${page_number + 1}`, {
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
        var sentinel = document.querySelector("#top-list .sentinel");
        sentinel.parentNode.removeChild(sentinel);

        container.insertAdjacentHTML('beforeend', data);

        var sentinel = document.querySelector("#top-list .sentinel");
        this.observer.observe(sentinel);
      })
      .catch(function (error) {
        console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
      });
  }
}