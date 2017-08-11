import socket from "../socket"
import Tippy from 'tippy.js/dist/tippy';
import MyCloudinary from './my-cloudinary';

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
      console.log("broadcasted");
      this.refresh_radio(payload)
    });
    document.addEventListener("click", function(e) {
      if (e.target && e.target.matches(".player__play__vinyl")) {
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

      if (e.target && e.target.matches(".player__expand")) {
        document.querySelector(".player__expand").classList.toggle("player__expand--open");
        document.querySelector(".already-played").classList.toggle("already-played--open");

      }
    });
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

    document.querySelector(".player__art img").dataset.src = "//res.cloudinary.com/don2kwaju/image/upload/w_auto/wsdjs/radiowcs_square.jpg";
    document.querySelector(".player__description__title").setAttribute("href", "#");
    document.querySelector(".player__description__title").innerHTML = "Radio WCS";
    document.querySelector(".player__description__sub-title").innerHTML = "by World Swing DJs";
    document.querySelector(".player").classList.toggle("player--playing");

    MyCloudinary.refresh();
  }

  play_radio(el) {
    this.radio.src = "http://www.radioking.com/play/radio-wcs";
    this.radio.load();

    this.channel.push("played_song_list")
    this.radio.play();
    document.querySelector(".player").classList.toggle("player--playing");
  }

  refresh_radio(payload) {
    var data = JSON.parse(payload.data);

    if (this.radio.paused == false) {
      document.querySelector(".player__art img").setAttribute("src", data[0].image_uri);
      document.querySelector(".player__art img").dataset.src = data[0].image_uri;
      document.querySelector(".player__description__title").setAttribute("href", data[0].path);
      document.querySelector(".player__description__title").innerHTML = data[0].title;
      document.querySelector(".player__description__sub-title").innerHTML = "by " + data[0].artist + ", " + data[0].suggested_by;
    }

    var played = ""
    for (var i = 1; i < data.length; i++) {
      played += `<tr><td class="small">${data[i].artist}</td><td class="small">${data[i].title}</td></tr>`;
    }
    var table = document.getElementById("already-played");
    if (table)
      table.innerHTML = played;
  }
}
