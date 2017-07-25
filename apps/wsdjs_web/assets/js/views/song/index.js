import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';
import timeago from 'timeago.js';
import Tippy from 'tippy.js/dist/tippy.standalone';

export default class View {
  constructor() {
    var self = this;
    
    this._cloudinary_uploader();

    var timeout;
    window.addEventListener("scroll", function(e) {
      if (document.querySelector("#song-list")) {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
          self._refresh();
        }, 100);
      }      
    })

    document.addEventListener("click", function(e) {
      if (e.target && e.target.matches(".SongIndexView .song-opinion")) {
        self._toggle_opinion(e.target);
        e.preventDefault();
      }

    }, false);
  }

  mount() {
    
  }

  _toggle_opinion(elem) {
    var self = this;
    console.log("toggle opinion")

    var container = elem.closest(".song-opinions");
    var method = elem.dataset.method;
    var url = elem.dataset.url;
    var token = document.querySelector("[name=channel_token]").getAttribute("content");

    var request = new XMLHttpRequest();
    request.open(method, url, true);
    request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
    request.setRequestHeader('Authorization', "Bearer " + token);
    request.setRequestHeader('Accept', 'application/json');

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        self._refresh_layout(container, JSON.parse(this.response));
      } else {
        console.error("Error");
      }
    };

    request.onerror = function() { console.error("Error"); };
    request.send();
  }

  _refresh_layout(container, data) {
    var song_up = container.querySelector(".song-up");
    var song_like = container.querySelector(".song-like");
    var song_down = container.querySelector(".song-down");

    this._refresh_kind(song_up, "up", data.data.up, data.data.user_opinion);
    this._refresh_kind(song_like, "like", data.data.like, data.data.user_opinion);
    this._refresh_kind(song_down, "down", data.data.down, data.data.user_opinion);
  }

  _refresh_kind(container, kind, data, user_opinion) {
    container.innerText = data.count;
    container.dataset.method = data.method;
    container.dataset.url = data.url;
    container.classList.remove("active")
    container.removeAttribute("title");

    if (user_opinion == kind) {
      container.classList.add("active")
    }
    var users = "";
    for (let i = 0; i < data.users.length && i < 8; i++) {
      users += data.users[i].name;
      if (i <= data.users.length - 1 || i == 8) {
        users += "<br />";
      }
    }
   
    container.setAttribute("title", users);
  }



  _refresh() {
    var pageHeight = document.documentElement.scrollHeight;
    var clientHeight = document.documentElement.clientHeight;
    var scrollPos = window.pageYOffset;

    if (pageHeight - (scrollPos + clientHeight) < 50) {
      var container = document.getElementById("song-list");
      var page_number = parseInt(container.dataset.jsPageNumber);
      var page_total = parseInt(container.dataset.jsTotalPages);

      if (page_number < page_total) {
        this._retrieve_songs(page_number + 1);
        new timeago().render(document.querySelectorAll("time.timeago"));
      }
    }
  }

  _retrieve_songs(page) {
    var self = this;
    var request = new XMLHttpRequest();
    request.open('GET', `/songs?page=${page}`, true);

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var total_pages = request.getResponseHeader("total-pages");
        var page_number = request.getResponseHeader("page-number");

        console.log(`${page_number} / ${total_pages}`);
        var container = document.getElementById("song-list");

        container.dataset.jsPageNumber = page_number;
        container.dataset.jsTotalPages = total_pages;

        container.insertAdjacentHTML('beforeend', this.response);

        var cl = cloudinary.Cloudinary.new();
        cl.init();
        cl.responsive();
        new timeago().render(document.querySelectorAll("time.timeago"));
      }
    };

    request.onerror = function() { console.log("Error search"); };

    request.send();
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