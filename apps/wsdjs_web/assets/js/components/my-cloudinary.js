import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

class MyCloudinary {
  constructor() {
    this._initIntersectionObserver();

    this.cl = cloudinary.Cloudinary.new();
    this.cl.init();

    this.refresh();
  }

  refresh() {
    var els = document.querySelectorAll('img:not(.cld-responsive)');
    // If we don't have support for intersection observer, loads the images immediately
  
    if (!('IntersectionObserver' in window)) {
      for (var i = 0; i < els.length; i++) {
        els[i].classList.add("cld-responsive");
      }
      this.cl.responsive();
    } else {
      for (i = 0; i < els.length; i++) {
        this.observer.observe(els[i]);
      }
    }
  }

  _initIntersectionObserver() {
    if ('IntersectionObserver' in window) {
      let self = this;
      this.observer = new IntersectionObserver(function(entries) {
        for (var i = 0; i < entries.length; i++) {
          if (entries[i].intersectionRatio > 0) {
            self.observer.unobserve(entries[i].target);
            entries[i].target.classList.add("cld-responsive");
          }
        }
        self.cl.responsive();
      });
    } else {
      console.log("IntersectionObserver not supported.");
    }
  }
}

export default new MyCloudinary();
