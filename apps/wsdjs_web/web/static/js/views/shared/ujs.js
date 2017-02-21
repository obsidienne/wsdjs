export default class glSearch {
  mount() {
    var elements = document.querySelectorAll("[data-remote=true]");

    Array.prototype.forEach.call(elements, function(el, i) {
      el.addEventListener("click", function(e) {
        var self = this;
        var method = this.dataset.method;
        var url = this.href;
        var csrf = document.querySelector("[name=csrf-token]");

        var request = new XMLHttpRequest();
        request.open(method, url, true);
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        request.setRequestHeader('x-csrf-token', csrf.getAttribute("content"));

        request.onreadystatechange = function() {
          if (this.readyState === 4) {
            if (this.status >= 200 && this.status < 400) {
              self.parentNode.innerHTML = this.responseText;
            } else {
              console.error("Error");
            }
          }
        }

        request.send();
        request = null;

        e.preventDefault();
      });
    });
  }
}
