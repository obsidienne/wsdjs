class Tabs {
  constructor() {
    var self = this;
    window.addEventListener('hashchange', function(e) { 
      self._hashChangeHandler(e);
    }, false);

    window.addEventListener('click', function(e) {
      if (e.target && e.target.matches(".tabs-navigation__item a")) {
        self._clickHandler(e);
      }
    }, false);
  }

  _clickHandler(event) {
    var el = event.target;
    document.querySelector(".tabs-navigation__item.active").classList.remove("active");
    el.closest(".tabs-navigation__item").classList.add("active");
  }

	_hashChangeHandler(event) {
    // Get hash from URL
    var hash = window.location.hash;
    if ( !hash ) return;

    // If there's a URL hash, activate tab with matching ID
    var toggle = document.querySelector(hash);

    document.querySelector(".tabs-pane.active").classList.remove("active");
    toggle.classList.add("active");

    let tab = document.querySelector(".tabs-navigation__item.active");
//    <li class="tabs-navigation__item active"><a data-tab data-turbolinks="false" href="#overview-section">overview</a></li>
  //  <li class="tabs-navigation__item"><a data-tab data-turbolinks="false" href="#videos-section">videos</a></li>
  
  };  
}

export default new Tabs();
