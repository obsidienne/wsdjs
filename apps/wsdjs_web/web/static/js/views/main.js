//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
import $ from 'jquery';

export default class MainView {
  // This will be executed when the document loads...
  mount() {
    this.menubar();
    console.log('MainView mounted');
  }

  unmount() {
    // This will be executed when the document unloads...
    console.log('MainView unmounted');
  }

  // private function used to show and hide menu from the menubar
  menubar() {
    var self = this;

    // click outside elements (bubble to document)
    document.addEventListener("click", function(event){
       if (!$(event.target).closest('.glheader__user').length &&
           !$(event.target).closest('.glsearch').length) {
         self._hide_menu_element();
       }
    });

    // click on search
    var glSearch = document.getElementById("glsearch");
    glSearch.addEventListener('click', function(e){
      self._hide_menu_element();

      let search_results = document.querySelector(".glsearch__results");
      let glsearch = document.querySelector(".glsearch");

      glsearch.classList.add("glsearch--focused");
      search_results.classList.add("glsearch--focused");
    });

    // switch between dropdown menu element
    var menuIcons = document.querySelectorAll(".glheader__menu-icon");
    Array.prototype.forEach.call(menuIcons, function(el, i){
      el.addEventListener("click", function(e) {
        var himself = this.nextElementSibling.classList.contains("glheader__menu--open");
        self._hide_menu_element();

        if (himself == false) {
          this.nextElementSibling.classList.add("glheader__menu--open");
        }
      });
    });
  }

  _hide_menu_element() {
    // close everything
    var elements = document.querySelectorAll(".glheader__menu--open");
    Array.prototype.forEach.call(elements, function(el, i){
      el.classList.remove("glheader__menu--open");
    });

    // remove focus
    var elements = document.querySelectorAll(".glsearch--focused");
    Array.prototype.forEach.call(elements, function(el, i){
      el.classList.remove("glsearch--focused");
    });

    // remove data from the result list
    document.querySelector(".glsearch__results").innerHtml = "";

    // remove searched string
    document.getElementById("glsearch").value = "";
  }
}
