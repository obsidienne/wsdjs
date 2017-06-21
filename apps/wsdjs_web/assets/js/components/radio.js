import socket from "../socket"

export default class Radio {
  mount() {
    var self = this;
    var radio = new Audio("http://37.58.75.166:8384/stream?icy=http");

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
        if (!radio.paused) { // play to pause
          radio.pause();
          e.target.classList.add("icon-play");
          e.target.classList.remove("icon-pause");
          document.querySelector(".miniplayer-art img").src = '//res.cloudinary.com/don2kwaju/image/upload/e_blur:300/o_30/v1449163830/wsdjs/brand.jpg';
          document.querySelector(".miniplayer-title").innerText = '';
          document.querySelector(".miniplayer-artist").innerText = '';
        } else { // pause to play
          channel.push("played_song_list")
          radio.play();
          e.target.classList.add("icon-pause");
          e.target.classList.remove("icon-play");
        }
      }
    });
    console.log('Radio component mounted');
  }

  refresh(payload) {
    var player = document.querySelector(".miniplayer");

    var data = JSON.parse(payload.data);

    var playing = "";
    for (let i = 1; i < data.length && i < 5; i++) {
      playing = `<li>
          <a href="${data[i].path}" class="played-song">
            <img height="50" width="50" src="${data[i].image_uri}" />
          </a>
        </li>` + playing;
    }

    playing += `<li>
      <div id="miniplayer" class="player">
        <a href="${data[0].path}" class="miniplayer-info">
          <div class="miniplayer-title">${data[0].title}</div>
          <div class="miniplayer-artist">${data[0].artist}</div>
        </a>

        <div class="miniplayer-art">
          <div class="toggle-player icon-pause"></div>
          <img height="50" width="50" src="${data[0].image_uri}" />
        </div>
      </div>
    </li>`

    player.innerHTML = playing;
  }
}
