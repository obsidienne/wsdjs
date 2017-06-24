import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    this.cloudinary();
    this.algolia();

    console.log('UserEditView mounted');
  }

  cloudinary() {
    var params = { upload_preset: "music_cover_staging",
                   cloud_name: "don2kwaju",
                   cropping: "server",
                   cropping_aspect_ratio: 1,
                   thumbnail_transformation: { width: 300, crop: 'crop', gravity: 'custom' } };

    var uploaded = function() {
      cloudinary.openUploadWidget(params, function(error, result) {
        document.getElementById("avatar_thumbnail").setAttribute("src", result[0]['thumbnail_url']);
        document.getElementById("user_avatar_cld_id").value = result[0]['public_id'];
        document.getElementById("user_avatar_version").value = result[0]['version'];
      })
    };

    document.getElementById("upload_widget_opener").addEventListener("click", uploaded, false);
  }

  algolia() {
    places({
      container: document.querySelector('#user_country'),
      type: 'country',
      templates: {
        suggestion: function(suggestion) {
          return '<i class="flag ' + suggestion.countryCode + '"></i> ' +  suggestion.highlight.name;
        }
      }
    })
  }
}
