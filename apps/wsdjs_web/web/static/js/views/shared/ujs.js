/*
<meta charset="UTF-8" content="" csrf-param="_csrf_token" method-param="_method" name="csrf-token">
*/
export default class glSearch {
  mount() {
    var elements = document.querySelectorAll("[data-remote=true]");

    Array.prototype.forEach.call(elements, function(el, i){
      el.addEventListener("click", function(e) {
        var method = this.dataset.method;
        var url = this.href;
        var csrf = document.querySelector("[name=csrf-token]");

        var request = new XMLHttpRequest();
        request.open('POST', url, true);
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        request.setRequestHeader('x-csrf-token', csrf.getAttribute("content"));
        request.send();


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
