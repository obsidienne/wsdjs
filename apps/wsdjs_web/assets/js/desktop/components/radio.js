import socket from "../socket"
import Tippy from 'tippy.js/dist/tippy';

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
      if (!e.target) return;

      if (e.target.matches(".player__play__vinyl")) {
        if (self.radio.paused) {
          self.play_radio(e.target)
        } else {
          self.pause_radio(e.target)
        }
      }

      if (e.target.matches("[data-video-id]")) {
        e.preventDefault();
        e.stopPropagation();
        self.play_youtube(e.target.dataset.videoId);
      }

      if (e.target.closest("a")) {
        if (e.target.closest("a").matches("[data-video-id]")) {
          e.preventDefault();
          e.stopPropagation();
          self.play_youtube(e.target.closest("a").dataset.videoId);
        }
      }

      if (e.target.matches(".player__toggle") || e.target.closest(".player__toggle")) {
        self.pause_youtube();
      }

      if (e.target.matches(".player__expand")) {
        document.querySelector(".player__expand").classList.toggle("player__expand--open");
        document.querySelector(".already-played").classList.toggle("already-played--open");
      }
    });
    document.addEventListener("change", function(e) {
      if (e.target && e.target.matches("#player__volume")) {
        var volumeElement = document.getElementById("player__volume");
        var volume = volumeElement.value;
        self.radio.volume = volume / 100;
      }
    });
  }

  setVolume(vol) {
    this.radio.volume = vol;
  }

  play_youtube(video_id) {
    document.querySelector(".player__expand").classList.remove("player__expand--open");
    document.querySelector(".already-played").classList.remove("already-played--open");

    this.pause_radio();
    document.querySelector(".current-played").setAttribute("hidden", "hidden");
    
    document.querySelector(".player__toggle").removeAttribute("hidden", "hidden");    
    var container = document.querySelector("#player__youtube");
    container.innerHTML = `<iframe src="https://www.youtube.com/embed/${video_id}" frameborder="0" allowfullscreen="1"></iframe>`;
    container.removeAttribute("hidden");
  }

  pause_youtube() {
    var container = document.querySelector("#player__youtube");
    container.setAttribute("hidden", "hidden");
    container.innerHTML = "";
    document.querySelector(".player__toggle").setAttribute("hidden", "hidden");

    document.querySelector(".current-played").removeAttribute("hidden", "hidden");
  }

  pause_radio(el) {
    this.radio.pause();
    this.radio.src = "about:blank";
    this.radio.load();

    document.querySelector(".player__art img").dataset.src = "//res.cloudinary.com/don2kwaju/image/upload/w_auto/wsdjs/radiowcs_square.jpg";
    document.querySelector(".player__description__title").setAttribute("href", "#");
    document.querySelector(".player__description__title").innerHTML = "Radio WCS";
    document.querySelector(".player__description__sub-title").innerHTML = "by World Swing DJs";
    document.querySelector(".player").classList.remove("player--playing");

    MyCloudinary.refresh();
  }

  play_radio(el) {
    this.radio.src = "http://www.radioking.com/play/radio-wcs";
    this.radio.load();

    this.channel.push("played_song_list")
    this.radio.play();
    document.querySelector(".player").classList.add("player--playing");
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
