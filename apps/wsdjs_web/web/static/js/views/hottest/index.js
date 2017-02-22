import timeago from 'timeago.js';
import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    new timeago().render(document.querySelectorAll("time.timeago"));
    this._intlDate();
    this._set_opinion();

    // Specific logic here
    console.log('HottestIndexView mounted');
  }

  unmount() {
    super.unmount();

    // Specific logic here
    console.log('HottestIndexView unmounted');
  }

  _intlDate() {
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);

    var elements = document.querySelectorAll("time:not(.timeago)");
    for (let i = 0; i < elements.length; i++) {
      let datetime = Date.parse(elements[i].getAttribute("datetime"))
      elements[i].textContent = dateTimeFormat.format(datetime);
    }
  }

  _set_opinion() {
    document.addEventListener("click",function(e) {
      if (e.target && e.target.matches(".song-opinion")) {
        e.preventDefault();

        var self = e.target;
        var method = e.target.dataset.method;
        var url = e.target.href;
        var token = document.querySelector("[name=channel_token]").getAttribute("content");

        var request = new XMLHttpRequest();
        request.open(method, url, true);
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        request.setRequestHeader('Authorization', "Bearer " + token);
        request.setRequestHeader('Accept', 'application/json');

        request.onload = function() {
          if (this.status >= 200 && this.status < 400) {
            // Success!
            self.parentNode.innerHTML = this.response;
          } else {
            console.error("Error");
            // We reached our target server, but it returned an error
          }
        };

        // There was a connection error of some sort
        request.onerror = function() { console.error("Error"); };
        request.send();
	     }
    });
  }
}
