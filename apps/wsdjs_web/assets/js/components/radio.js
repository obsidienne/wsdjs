import socket from "../socket"
import Tippy from 'tippy.js/dist/tippy.standalone';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class Radio {
  constructor() {
    var self = this;
    this.radio = new Audio();


    // Now that you are connected, you can join channels with a topic:
    this.channel = socket.channel("notifications:now_playing", {})
    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    this.channel.on("new_played_song", payload => {
      this.refresh_radio(payload)
    });
    document.addEventListener("click", function(e) {
      if (e.target && e.target.matches(".toggle-player")) {
        if (self.radio.paused) {
          self.play_radio(e.target)
        } else {
          self.pause_radio(e.target)
        }
      }

      if (e.target && e.target.matches("[data-video-id]")) {
        e.preventDefault();
        e.stopPropagation();
        self.play_youtube(e.target.dataset.videoId);
      }

      if (e.target && (e.target.matches(".miniplayer-radio-toggle") || e.target.closest(".miniplayer-radio-toggle"))) {
        self.pause_youtube();
      }
    });
    console.log('Radio component mounted');
  }


  play_youtube(video_id) {
    this.pause_radio(document.querySelector(".toggle-player"))
    document.querySelector(".miniplayer-art").setAttribute("hidden", "hidden");
    document.querySelector("#radio-container").setAttribute("hidden", "hidden");
    document.getElementById("miniplayer-container").classList.add("youtube");
    document.querySelector(".miniplayer-radio-toggle").removeAttribute("hidden");

    var container = document.querySelector("#youtube-player");
    container.innerHTML = `<iframe src="https://www.youtube.com/embed/${video_id}?autoplay=1" frameborder="0" allowfullscreen="1"></iframe>`;
    container.removeAttribute("hidden");
  }

  pause_youtube() {
    var container = document.querySelector("#youtube-player");
    container.setAttribute("hidden", "hidden");
    container.innerHTML = "";
    document.querySelector(".miniplayer-radio-toggle").setAttribute("hidden", "hidden");

    document.querySelector(".miniplayer-art").removeAttribute("hidden");
    document.querySelector("#radio-container").removeAttribute("hidden");
    document.getElementById("miniplayer-container").classList.remove("youtube");
  }

  pause_radio(el) {
    this.radio.pause();
    this.radio.src = "about:blank";
    this.radio.load();
    el.classList.add("icon-play");
    el.classList.remove("icon-pause");
    document.querySelector(".miniplayer-art img").dataset.src = '///res.cloudinary.com/don2kwaju/image/upload/w_auto/wsdjs/radiowcs_square.jpg';
    document.querySelector(".miniplayer-info h6:first-child").innerHTML = "";
    document.querySelector(".miniplayer-info h6:nth-child(2)").innerHTML = "";
    document.querySelector(".miniplayer-info h6:last-child").innerHTML = "Play the radio";

    document.querySelector(".miniplayer").classList.toggle("paused");
    document.querySelector("#radio-container").innerHTML = "";
    var cl = cloudinary.Cloudinary.new();
    cl.init();
    cl.responsive();
  }

  play_radio(el) {
    this.radio.src = "http://37.58.75.166:8384/stream?icy=http";
    this.radio.load();

    this.channel.push("played_song_list")
    this.radio.play();
    el.classList.add("icon-pause");
    el.classList.remove("icon-play");
    document.querySelector(".miniplayer").classList.toggle("paused");
  }

  refresh_radio(payload) {
    if (this.radio.paused) {
      return;
    }
    var data = JSON.parse(payload.data);

    if (data[0] !== undefined) {
      document.querySelector(".miniplayer-art img").setAttribute("src", data[0].image_uri);
      document.querySelector(".miniplayer-art img").dataset.src = data[0].image_uri;
      document.querySelector(".miniplayer-info").setAttribute("href", data[0].path);
      document.querySelector(".miniplayer-info h6:first-child").innerHTML = data[0].title;
      document.querySelector(".miniplayer-info h6:nth-child(2)").innerHTML = data[0].artist;
      document.querySelector(".miniplayer-info h6:last-child").innerHTML = `<span class="suggested_by">suggested by ${data[0].suggested_by}</span>`;
    }


    var playing = "";
    for (let i = 1; i < data.length && i < 5; i++) {
      if (data[0] !== undefined) {
        playing += `<li class="played-song tippy" data-position="top-end" data-size="small" title="${data[i].artist} - ${data[i].title}<br/><span class='small'>Suggested by ${data[i].suggested_by}</span>"><a href="${data[i].path}"><img height="50" width="50" class="responsive cld-responsive" src="${data[i].image_uri}" /></a></li>`;
      } else {
        playing += `<li class="played-song tippy" data-position="top-end" data-size="small" title="${data[i].artist} - ${data[i].title}<br/><span class='small'>Suggested by ${data[i].suggested_by}</span>"><a href="${data[i].path}"><img height="50" width="50" class="responsive cld-responsive" src="//res.cloudinary.com/don2kwaju/image/upload/v1449164620/wsdjs/missing_cover.jpg" /></a></li>`;        
      }
    }
    document.querySelector("#radio-container").innerHTML = playing;

    new Tippy('.tippy-radio');
  }
}
