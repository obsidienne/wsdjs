import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class View {
  constructor() {
    this._cloudinary_uploader();
  }

  _cloudinary_uploader() {
    var params = { upload_preset: "music_cover_staging",
                   cloud_name: "don2kwaju",
                   cropping: "server",
                   cropping_aspect_ratio: 1,
                   thumbnail_transformation: { crop: 'crop', gravity: 'custom' } };

    var uploaded = function() {
      cloudinary.openUploadWidget(params, function(error, result) {
      })
    };

    document.addEventListener("click", function(e) {
      if (e.target && e.target.matches("#song_upload_widget_opener")) {
        cloudinary.openUploadWidget(params, function(error, result) {
          document.getElementById("art_thumbnail").setAttribute("src", result[0]['thumbnail_url']);
          document.getElementById("song_art_cld_id").value = result[0]['public_id'];
          document.getElementById("song_art_version").value = result[0]['version'];
          document.getElementById("song_art_cld_id").removeAttribute("disabled");
          document.getElementById("song_art_version").removeAttribute("disabled");
        });
      }
    }, false);
  }
}