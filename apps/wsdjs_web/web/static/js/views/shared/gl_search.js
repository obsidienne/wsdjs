import timeago from 'timeago.js';
import $ from 'jquery';

export default class glSearch {
  mount() {
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
  }
}
