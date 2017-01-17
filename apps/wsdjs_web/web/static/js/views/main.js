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
    $(document).on("click", function(event){
      if (!$(event.target).closest('.glsearch').length) {
         $('.glsearch').removeClass('glsearch--focused');
         $(".glsearch__results").html("");
         $("#glsearch").val("");
       }
       if (!$(event.target).closest('.glheader__user').length &&
           !$(event.target).closest('.glsearch').length) {
         $(".glheader .glheader__menu--open").toggleClass("glheader__menu--open" );
         $(".glsearch__results").html("");
         $(".glsearch__results").removeClass("glsearch--focused")
       }
    });

    $('#glsearch').on('click', function(e){
      $('.glsearch__results').addClass('glsearch--focused');
      $(".glheader .glheader__menu--open").toggleClass("glheader__menu--open" );
      $('.glsearch').addClass("glsearch--focused");
    });

    $(function() {
      $(".glheader__menu-icon").on("click", function(e) {
        if ($(this).next().hasClass("glheader__menu--open")) {
          $(this).next().removeClass( "glheader__menu--open" );
          $('.glsearch--focused').removeClass('glsearch--focused');
        } else {
          $('.glsearch--focused').removeClass('glsearch--focused');
          $(".glheader .glheader__menu--open").toggleClass("glheader__menu--open" );
          $(this).next().addClass( "glheader__menu--open" );
        }
      })
    });
  }
}
