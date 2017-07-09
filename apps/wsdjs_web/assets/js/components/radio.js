import socket from "../socket"
import Tippy from 'tippy.js/dist/tippy';

export default class Radio {
  mount() {
    var self = this;
    this.radio = new Audio("http://37.58.75.166:8384/stream?icy=http");

    // Now that you are connected, you can join channels with a topic:
    let channel = socket.channel("notifications:now_playing", {})
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("new_played_song", payload => {
      this.refresh(payload)
    });

    document.addEventListener("click", function(e) {
      if (e.target && e.target.matches(".toggle-player")){
        if (!self.radio.paused) { // play to pause
          self.radio.pause();
          e.target.classList.add("icon-play");
          e.target.classList.remove("icon-pause");
          document.querySelector(".miniplayer-art img").src = '//res.cloudinary.com/don2kwaju/image/upload/wsdjs/radiowcs_square.jpg';
          var current_play_title = document.querySelector(".miniplayer-info h6:first-child");
          var current_play_artist = document.querySelector(".miniplayer-info h6:nth-child(2)");
          var current_play_suggestor = document.querySelector(".miniplayer-info h6:last-child");
          current_play_title.innerHTML = "";
          current_play_artist.innerHTML = "";
          current_play_suggestor.innerHTML = "Play the radio";

        } else { // pause to play
          channel.push("played_song_list")
          self.radio.play();
          e.target.classList.add("icon-pause");
          e.target.classList.remove("icon-play");
        }
      }
    });
    console.log('Radio component mounted');
  }

  refresh(payload) {
    var player = document.querySelector("#radio-container");


    var data = JSON.parse(payload.data);

    var playing = "";
    var max_it = 5;
    if (document.documentElement.clientHeight <= 480) {
      max_it = 2
    }
    for (let i = 1; i < data.length && i < max_it; i++) {
      playing += `<li class="played-song tippy" data-position="top-end" data-size="small" title="${data[i].artist} - ${data[i].title}<br/><span class='small'>Suggested by ${data[i].suggested_by}</span>"><a href="${data[i].path}"><img height="50" width="50" src="${data[i].image_uri}" /></a></li>`;
    }

    var art = document.querySelector(".miniplayer-art img");
    art.setAttribute("src", data[0].image_uri);

    var current_play = document.querySelector(".miniplayer-info");
    var current_play_title = document.querySelector(".miniplayer-info h6:first-child");
    var current_play_artist = document.querySelector(".miniplayer-info h6:nth-child(2)");
    var current_play_suggestor = document.querySelector(".miniplayer-info h6:last-child");

    current_play.setAttribute("href", data[0].path);
    current_play_title.innerHTML = data[0].title;
    current_play_artist.innerHTML = data[0].artist;
    current_play_suggestor.innerHTML = `<span class="suggested_by">suggested by ${data[0].suggested_by}</span>`;

    console.log(playing);
    player.innerHTML = playing;
    new Tippy('.tippy');

  }
}
