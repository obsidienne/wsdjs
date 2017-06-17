export default class Radio {
  mount() {
    var self = this;
    var radio = new Audio("http://37.58.75.166:8384/stream?icy=http");

    var timer;
    document.addEventListener("click", function(e) {
      if (e.target && e.target.matches(".toggle-player")){
        if (!radio.paused) { // play to pause
          clearInterval(timer);
          radio.pause();
          e.target.classList.add("icon-play");
          e.target.classList.remove("icon-pause");
          document.querySelector(".miniplayer-art img").src = 'http://res.cloudinary.com/don2kwaju/image/upload/e_blur:300/o_30/v1449163830/wsdjs/brand.jpg';
          document.querySelector(".miniplayer-title").innerText = 'waiting..';
          document.querySelector(".miniplayer-artist").innerText = '';
        } else { // pause to play
          self._metadata()
          timer = setInterval(function() { self._metadata() }, 5000);
          radio.play();
          e.target.classList.add("icon-pause");
          e.target.classList.remove("icon-play");
        }
      }
    });
  }

  _metadata() {
    var request = new XMLHttpRequest();
    request.open('GET', 'http://anchorstep.radiowcs.com/lastest/', true);

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        var data = JSON.parse(this.response);
        document.querySelector(".miniplayer-title").innerText = data[0].title;
        document.querySelector(".miniplayer-artist").innerText = data[0].artist;
        document.querySelector(".miniplayer-art img").src = data[0].image;
      } else { }
    };

    request.onerror = function() {
      // There was a connection error of some sort
    };
    request.send();
  }
}
