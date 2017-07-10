import socket from "../socket"
import Tippy from 'tippy.js/dist/tippy';

export default class Radio {
  mount() {
    var self = this;
    this.radio = new Audio("http://37.58.75.166:8384/stream?icy=http");

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
        self.youtube(e.target.dataset.videoId);
      }
    }
    );
    console.log('Radio component mounted');
  }

  youtube(video_id) {
    console.log(video_id);
  }

  pause_radio(el) {
    this.radio.pause();
    el.classList.add("icon-play");
    el.classList.remove("icon-pause");
    document.querySelector(".miniplayer-art img").src = '//res.cloudinary.com/don2kwaju/image/upload/wsdjs/radiowcs_square.jpg';
    document.querySelector(".miniplayer-info h6:first-child").innerHTML = "";
    document.querySelector(".miniplayer-info h6:nth-child(2)").innerHTML = "";
    document.querySelector(".miniplayer-info h6:last-child").innerHTML = "Play the radio";
  }

  play_radio(el) {
    this.channel.push("played_song_list")
    this.radio.play();
    el.classList.add("icon-pause");
    el.classList.remove("icon-play");
  }

  refresh_radio(payload) {
    var data = JSON.parse(payload.data);

    document.querySelector(".miniplayer-art img").setAttribute("src", data[0].image_uri);;
    document.querySelector(".miniplayer-info").setAttribute("href", data[0].path);;
    document.querySelector(".miniplayer-info h6:first-child").innerHTML = data[0].title;;
    document.querySelector(".miniplayer-info h6:nth-child(2)").innerHTML = data[0].artist;;
    document.querySelector(".miniplayer-info h6:last-child").innerHTML = `<span class="suggested_by">suggested by ${data[0].suggested_by}</span>`;;

    var playing = "";
    for (let i = 1; i < data.length && i < 5; i++) {
      playing += `<li class="played-song tippy" data-position="top-end" data-size="small" title="${data[i].artist} - ${data[i].title}<br/><span class='small'>Suggested by ${data[i].suggested_by}</span>"><a href="${data[i].path}"><img height="50" width="50" src="${data[i].image_uri}" /></a></li>`;
    }
    document.querySelector("#radio-container").innerHTML = playing;

    new Tippy('.tippy');
  }
}
