import MainView from '../main';

export default class View extends MainView {
  constructor() {
    super();
    this._cloudinary();
  }

  mount() {
    super.mount();
    places({
      container: document.querySelector('#user_country'),
      type: 'country'
    })
  }

  _cloudinary() {
    var params = {
      upload_preset: "music_cover",
      cloud_name: "don2kwaju",
      cropping: "server",
      cropping_aspect_ratio: 1,
      thumbnail_transformation: {
        crop: 'crop',
        gravity: 'custom'
      }
    };

    document.addEventListener("click", function (e) {
      if (e.target && e.target.matches("#user_upload_widget_opener")) {
        cloudinary.openUploadWidget(params, function (error, result) {
          document.getElementById("avatar_thumbnail").setAttribute("src", result[0]['thumbnail_url']);
          document.getElementById("user_avatar_cld_id").value = result[0]['public_id'];
          document.getElementById("user_avatar_version").value = result[0]['version'];
          document.getElementById("user_avatar_cld_id").removeAttribute("disabled");
          document.getElementById("user_avatar_version").removeAttribute("disabled");

          var formElement = document.querySelector("#avatar_div form");
          var request = new XMLHttpRequest();
          request.open("POST", formElement.getAttribute("action"));
          request.send(new FormData(formElement));

        })
      }
    }, false);
  }
}