import Places from 'places.js/dist/cdn/places.js';

export default class View {
  constructor() {
    this._cloudinary();
  }

  mount() {
    Places({
      container: document.querySelector('#user_country'),
      type: 'country',
      templates: {
        suggestion: function(suggestion) {
          return '<i class="flag ' + suggestion.countryCode + '"></i> ' +  suggestion.highlight.name;
        }
      }
    })
  }

  _cloudinary() {
    var params = { upload_preset: "music_cover_staging",
                   cloud_name: "don2kwaju",
                   cropping: "server",
                   cropping_aspect_ratio: 1,
                   thumbnail_transformation: { crop: 'crop', gravity: 'custom' } };

    document.addEventListener("click", function(e) {
        if (e.target && e.target.matches("#user_upload_widget_opener")) {
            cloudinary.openUploadWidget(params, function(error, result) {
                document.getElementById("avatar_thumbnail").setAttribute("src", result[0]['thumbnail_url']);
                document.getElementById("user_avatar_cld_id").value = result[0]['public_id'];
                document.getElementById("user_avatar_version").value = result[0]['version'];
            })
        }
    }, false);
  }
}
