class LazyLoad {
  constructor() {
    this._initIntersectionObserver();
    this.refresh();
  }

  refresh() {
    if (this.observer == null) return;
    this.observer.disconnect();

    var els = document.querySelectorAll('img[data-src]');

    for (var i = 0; i < els.length; i++) {
      this.observer.observe(els[i]);
    }
  }
  _initIntersectionObserver() {
    let self = this;
    this.observer = new IntersectionObserver(function (entries) {
      for (var i = 0; i < entries.length; i++) {
        if (entries[i].isIntersecting) {
          self.observer.unobserve(entries[i].target);
          entries[i].target.setAttribute("src", entries[i].target.dataset.src);
          entries[i].target.setAttribute("srcset", entries[i].target.dataset.srcset);
          delete entries[i].target.dataset.src;
          delete entries[i].target.dataset.srcset;
        }
      }
    });
  }
}

export default new LazyLoad();