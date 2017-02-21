export default class glSearch {
  mount() {
    var elements = document.querySelectorAll("[data-remote=true]");

    Array.prototype.forEach.call(elements, function(el, i) {
      el.addEventListener("click", function(e) {
        var self = this;
        var method = this.dataset.method;
        var url = this.href;
        var csrf = document.querySelector("[name=csrf-token]");
        var token = document.querySelector("[name=channel_token]").content;

        var request = new XMLHttpRequest();
        request.open(method, url, true);
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        request.setRequestHeader('x-csrf-token', csrf.getAttribute("content"));
        request.setRequestHeader('Authorization', "Bearer " + token);

        request.onload = function() {
          if (this.status >= 200 && this.status < 400) {
            // Success!
            var resp = this.response;
            self.parentNode.innerHTML = resp;
          } else {
            console.error("Error");
            // We reached our target server, but it returned an error
          }
        };

        request.onerror = function() {
          // There was a connection error of some sort
          console.error("Error");
        };

        request.send();

        e.preventDefault();
      });
    });
  }
}
