import Tippy from 'tippy.js/dist/tippy.standalone';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class opinion {
  mount() {
    var self = this;

    console.log("opinion component mounted");
    document.addEventListener("click", function(e) {
      if (e.target && e.target.matches(".song-opinion")) {
        self._toggle_opinion(e.target);
        e.preventDefault();
      }
    });
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

    new Tippy('.tippy');
    var cl = cloudinary.Cloudinary.new();
    cl.init();
    cl.responsive();
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

    var tmp = container.closest("tr");
    if (tmp) {
      var users = "";
      for (let i = 0; i < data.users.length && i < 8; i++) {
        users += `<a href="${data.users[i].url}"><img class="img-circle cld-responsive avatar-tiny tippy" data-size="small" data-src="${data.users[i].avatar}" title="${data.users[i].name}"></a>`;
      }
      tmp.querySelector("td").innerHTML = users;
    } else {
      var users = "";
      for (let i = 0; i < data.users.length && i < 8; i++) {
        users += data.users[i].name;
        if (i == data.users.length - 1 || i == 8) {
          users += "<br />";
        }
      }
      container.setAttribute("title", users);
    }
  }
}
