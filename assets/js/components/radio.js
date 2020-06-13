
export default class Radio {
  constructor() {
    var self = this;

    // Now that you are connected, you can join channels with a topic:
    this.channel = socket.channel("radio:streamed", {})
    this.channel.join()
      .receive("ok", resp => {
        console.log("Radio stream successfully joined", resp)
      })
      .receive("error", resp => {
        console.log("Unable to join the radio stream", resp)
      })

    this.channel.on("new_streamed_song", payload => {
      console.log("New song streamed");
      this.refresh_radio(payload)
    });

    document.addEventListener("click", function (e) {
      if (!e.target) return;

      if (e.target.matches(".radio-toggle-play")) {
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
    let radio = document.getElementById("audio_player");
    if (radio.paused == false) {
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
    let radio = document.getElementById("audio_player");

    if (radio.paused == true) {
      radio.src = "http://www.radioking.com/play/radio-wcs";
      radio.load();
      radio.play();

      this.channel.push("list_song") // remove this ?
    } else {
      radio.pause();
      radio.src = "about:blank";
      radio.load(); // stop the stream not only the player
    }
    document.querySelector("body").classList.toggle("radio-playing");
  }

  /*
    this function is used to update
      - the radio player
      - the radio page
  */
  refresh_radio(payload) {
    if (payload.data == "")
      return;

    var data = JSON.parse(payload.data);

    /* update the radio player */
    document.querySelector(".player__art img").setAttribute("src", data[0].image_uri);
    document.querySelector(".player__art img").setAttribute("srcset", data[0].image_srcset);
    document.querySelector("#player-title").setAttribute("href", data[0].path);
    document.querySelector("#player-title").innerHTML = data[0].title;
    document.querySelector("#player-suggestor").innerHTML = "by " + data[0].artist + ", " + data[0].suggested_by;

    /* update the song page but only if we are in the song page */
    if (document.querySelector(".radio-song img")) {
      document.querySelector(".radio-song img").setAttribute("src", data[0].image_uri);
      document.querySelector(".radio-song img").setAttribute("srcset", data[0].image_srcset);
      document.querySelector(".radio-suggestor").setAttribute("href", data[0].suggested_by_path);
      document.querySelector(".radio-suggestor").innerHTML = data[0].suggested_by;
      document.querySelector(".radio-song_body").innerHTML = data[0].title;
    }
  }
}