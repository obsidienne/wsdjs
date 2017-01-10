App.Songs = function() {
  $(".form_song .cover").on( "click", function() {
    cloudinary.openUploadWidget(song_cover_upload_options, function(error, result) {
    });
  });

  //if not authenticated, no vote !
  if (!$("body").hasClass("authenticated")) {
    $(document).on("ajax:before", "a.song-opinion", function() { return false });
  }

  $( document ).on( "ajax:success", "a.song-opinion", function(e, data, status, xhr) {
    var el = $(e.target);
    var article = el.parents(".song-opinions");
    article.html(data);
    article.data("loaded", true);
    $('[data-toggle="tooltip"]').tooltip();
  }).on('ajax:error', function(e, data, status, xhr) {
    alert("error");
  });

  $(".song-opinions").on("mouseenter", function() {
    if ($(this).data("loaded") != true) {
      var self = $(this);
      var song = $(this).parent("article");

      $.get('/songs/'+song.data("id")+'/votes').done(function( data ) {
        $(".song-opinions", song).html(data);
        $('[data-toggle="tooltip"]').tooltip();
        self.data("loaded", true);
      });
    }
  });
}



$(document).on("page:change", function() {
  return App.Songs();
});
$(function() { return App.Songs(); })
