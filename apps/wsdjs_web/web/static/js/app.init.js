window.App || (window.App = {});

App.init = function() {

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
};

$(document).on("page:change", function() {
  return App.init();
});

$(function() { return App.init(); })
