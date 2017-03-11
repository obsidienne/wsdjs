import timeago from 'timeago.js';
import Cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class glSearch {
  mount() {
    var timer;

    document.getElementById("glsearch").addEventListener('keyup', function() {
      clearTimeout(timer);  //clear any running timeout on key up
      timer = setTimeout(function() { //then give it a second to see if the user is finished
        var query = document.getElementById("glsearch").value;
        var token = document.querySelector("[name=channel_token]").getAttribute("content");

        var request = new XMLHttpRequest();
        request.open('GET', '/search?q='+query, true);
        request.setRequestHeader('Authorization', "Bearer " + token);

        request.onload = function() {
          if (this.status >= 200 && this.status < 400) {
            document.querySelector(".glsearch__results").innerHTML = this.response;
            new timeago().render(document.querySelectorAll(".glsearch__results time.timeago"));
            super._cloudinary();
          } else {
            document.querySelector(".glsearch__results").innerHTML = "";
          }
        };

        request.onerror = function() { console.log("Error search"); };

        request.send();
      }, 500);
    });
  }
}
