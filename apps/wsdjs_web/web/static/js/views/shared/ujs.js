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
        request.open('POST', url, true);
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        request.setRequestHeader('x-csrf-token', csrf.getAttribute("content"));

        request.onreadystatechange = function() {
          if (this.readyState === 4) {
            if (this.status >= 200 && this.status < 400) {
              self.parentNode.innerHTML = this.responseText;
              console.log(this.responseText);
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

/*
var timer;

document.getElementById("glsearch").addEventListener('keyup', function() {
  clearTimeout(timer);  //clear any running timeout on key up
  timer = setTimeout(function() { //then give it a second to see if the user is finished
    var query = document.getElementById("glsearch").value;

    $.get('/search', { q: query }).done(function( data ) {
      document.querySelector(".glsearch__results").innerHTML = data;
      new timeago().render(document.querySelectorAll(".glsearch__results time.timeago"));
    });
  }, 500);
});
*/
