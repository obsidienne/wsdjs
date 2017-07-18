import cloudinaryCore from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class User {
  constructor() {
    var self = this;

    var timeout;
    window.addEventListener("scroll", function(e) {
      if (document.querySelector("#user-profile-container")) {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
          var ticking = false;
          if (!ticking) {
            window.requestAnimationFrame(function() {
              self._refresh();
              ticking = false;
            });
          }
          ticking = true;
        }, 100);
      }      
    })

    this._cloudinary();

    console.log('UserShowView mounted');
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

  _refresh() {
    // stop there if we are not in the song index page
    var body = document.querySelector("body")
    if (! body.classList.contains("UserShowView"))
      return;
  
    var pageHeight = document.documentElement.scrollHeight;
    var clientHeight = document.documentElement.clientHeight;
    var scrollPos = window.pageYOffset;

    if (pageHeight - (scrollPos + clientHeight) < 50) {   
      var container = document.getElementById("song-list");
      var page_number = parseInt(container.dataset.jsPageNumber);
      var page_total = parseInt(container.dataset.jsTotalPages);
      var user_id = container.getAttribute("user-id");
        
      if (page_number < page_total) {
        this._retrieve_songs(user_id, page_number + 1);
      }      
    }
  }

  _retrieve_songs(user_id, page) {    
    var request = new XMLHttpRequest();    
    request.open('GET', `/songs?user_id=${user_id}&page=${page}`, true);
  
    request.onload = function() {        
      if (this.status >= 200 && this.status < 400) {
        var total_pages = request.getResponseHeader("total-pages");
        var page_number = request.getResponseHeader("page-number");

        console.log(`${page_number} / ${total_pages}`);
        var container = document.getElementById("song-list");

        container.dataset.jsPageNumber = page_number;
        container.dataset.jsTotalPages = total_pages;
        container.insertAdjacentHTML('beforeend', this.response);

        var cl = cloudinaryCore.Cloudinary.new();
        cl.init();
        cl.responsive();
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
  }
}
