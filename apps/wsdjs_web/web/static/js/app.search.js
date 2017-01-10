App.Search = function() {
  var timer;
  $('#glsearch').on('keyup', function() {
    clearTimeout(timer);  //clear any running timeout on key up
    timer = setTimeout(function() { //then give it a second to see if the user is finished
      var q = $('#glsearch').val();
      $.get('/searches', { q: q }).done(function( data ) {
        $(".glsearch__results").html(data);
        $("abbr.timeago").timeago();
      });

    }, 500);
  });
};

$(document).on("page:change", function() {
  return App.Search();
});

$(function() { return App.Search(); })
