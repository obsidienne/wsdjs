
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
    console.log("toggle opinion")

    var container = elem.parentNode;
    var method = elem.dataset.method;
    var url = elem.href;
    var token = document.querySelector("[name=channel_token]").getAttribute("content");

    var request = new XMLHttpRequest();
    request.open(method, url, true);
    request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
    request.setRequestHeader('Authorization', "Bearer " + token);
    request.setRequestHeader('Accept', 'application/json');

    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        container.innerHTML = this.response;
      } else {
        console.error("Error");
      }
    };

    request.onerror = function() { console.error("Error"); };
    request.send();
  }
}
