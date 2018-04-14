class Opinions {
  constructor() {

    document.addEventListener("click", e => {
      if (e.target && e.target.matches(".song-opinion")) {
        this._toggle_opinion(e.target);
        e.preventDefault();
        e.stopPropagation();
      }
    }, false);
  }

  _toggle_opinion(elem) {
    var token = document.querySelector("[name=channel_token]").getAttribute("content");

    fetch(elem.dataset.url, {
        method: elem.dataset.method,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
          "Accept": "application/json",
          "Authorization": `Bearer ${token}`
        }
      })
      .then((response) => {
        if (response.ok) {
          return response.json();
        } else {
          console.log('Mauvaise réponse du réseau');
        }
      })
      .then((data) => {
        var container = elem.closest(".song-opinions");
        this._refresh_layout(container, data);
      })
      .catch(function (error) {
        console.log('Il y a eu un problème avec l\'opération fetch: ' + error.message);
      });
  }

  _refresh_layout(container, data) {
    var song_up = container.querySelector(".song-up");
    var song_like = container.querySelector(".song-like");
    var song_down = container.querySelector(".song-down");

    this._refresh_kind(song_up, "up", data.data.up, data.data.user_opinion);
    this._refresh_kind(song_like, "like", data.data.like, data.data.user_opinion);
    this._refresh_kind(song_down, "down", data.data.down, data.data.user_opinion);
  }

  _refresh_kind(container, kind, data, user_opinion) {
    container.getElementsByTagName("span")[0].innerText = data.count;
    container.dataset.method = data.method;
    container.dataset.url = data.url;
    container.setAttribute("title", data.tooltip_html);
    container.classList.remove("active")

    if (user_opinion == kind) {
      container.classList.add("active")
    }
  }
}

export default new Opinions();