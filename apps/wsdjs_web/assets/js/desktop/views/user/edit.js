import Places from 'places.js/dist/cdn/places.js';
import MainView from '../main';
import Notifier from '../../components/notifier';

export default class View extends MainView {
  constructor() {
    super();
    this._cloudinary();
  }

  mount() {
    super.mount();
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
    var params = { upload_preset: "music_cover",
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
          document.getElementById("user_avatar_cld_id").removeAttribute("disabled");
          document.getElementById("user_avatar_version").removeAttribute("disabled");

          var formElement = document.querySelector("#avatar_div form");
          var request = new XMLHttpRequest();
          request.open("POST", formElement.getAttribute("action"));
          request.send(new FormData(formElement));

          request.onload = function() {
            if (this.status >= 200 && this.status < 400) {
              document.getElementById("notifier-container").innerHTML = `
              <div id="info-notification" class="notifier info" role="alert">
                <h2 class="notifier-title">Your avatar is correctly updated.</h2>
              </div>`;
            } else {
              document.getElementById("notifier-container").innerHTML = `
              <div id="info-notification" class="notifier danger" role="alert">
                <h2 class="notifier-title">Something went wrong.</h2>
              </div>`;
            }
            var notifier = new Notifier();
            notifier.show_all();
          };
          request.onerror = function() { 
            document.getElementById("notifier-container").innerHTML = `
                <div id="info-notification" class="notifier danger" role="alert">
                  <h2 class="notifier-title">Something went wrong.</h2>
                </div>`;
            };
            var notifier = new Notifier();
            notifier.show_all();
        })
      }
    }, false);
  }
}
