import socket from "../socket"

export default class Radio {
  constructor() {
    var self = this;
    this.radio = new Audio();

    // Now that you are connected, you can join channels with a topic:
    this.channel = socket.channel("radio:streamed", {})
    this.channel.join()
      .receive("ok", resp => {
        console.log("RadioWCS successfully joined", resp)
      })
      .receive("error", resp => {
        console.log("Unable to join RadioWCS", resp)
      })

    this.channel.on("new_streamed_song", payload => {
      console.log("RadioWCS stream a new song");
      this.refresh_radio(payload)
    });

    document.addEventListener("click", function (e) {
      if (!e.target) return;

      if (e.target.matches(".player__play__vinyl")) {
        self.toggle_radio(e.target);
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

      if (e.target.matches(".player__youtube_close")) {
        self.pause_youtube();
      }
    });
  }

  play_youtube(video_id) {
    if (this.radio.paused == false) {
      this.toggle_radio();
    }

    var player = document.querySelector("#player__youtube");
    player.innerHTML = `<iframe src="https://www.youtube.com/embed/${video_id}?autoplay=1" frameborder="0" allowfullscreen="1"></iframe>`;
    var container = document.getElementById("player__youtube__container");
    container.classList.add("open");
  }

  pause_youtube() {
    var player = document.querySelector("#player__youtube");
    player.innerHTML = "";
    var container = document.querySelector(".player__youtube__container.open");
    container.classList.remove("open");
  }

  toggle_radio(el) {
    if (this.radio.paused == true) {
      this.radio.src = "http://www.radioking.com/play/radio-wcs";
      this.radio.load();
      this.radio.play();

      this.channel.push("list_song") // remove this ?
    } else {

      this.radio.pause();
      this.radio.src = "about:blank";
      this.radio.load(); // stop the stream not only the player
    }

    document.querySelector(".player").classList.toggle("player--playing");
  }

  /*
    this function is used to update
      - the radio player
      - the radio page
  */
  refresh_radio(payload) {
    var data = JSON.parse(payload.data);

    /* update the radio player */
    document.querySelector(".player__art img").setAttribute("src", data[0].image_uri);
    document.querySelector(".player__art img").setAttribute("srcset", data[0].image_srcset);
    document.querySelector(".player__description__title").setAttribute("href", data[0].path);
    document.querySelector(".player__description__title").innerHTML = data[0].title;
    document.querySelector(".player__description__sub-title").innerHTML = "by " + data[0].artist + ", " + data[0].suggested_by;

    /* update the song page */
    document.querySelector(".radio-song img").setAttribute("src", data[0].image_uri);
    document.querySelector(".radio-song img").setAttribute("srcset", data[0].image_srcset);
    document.querySelector(".radio-suggestor").setAttribute("href", data[0].suggested_by_path);
    document.querySelector(".radio-suggestor").innerHTML = data[0].suggested_by;
    document.querySelector(".radio-song_body").innerHTML = data[0].title;
  }
}