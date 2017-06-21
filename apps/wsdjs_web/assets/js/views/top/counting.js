import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    this._bonus();

    // Specific logic here
    console.log('TopCountingView mounted');
  }

  _bonus() {
    document.addEventListener("click", function(e) {
      let elem = e.target;
      if (elem && (elem.matches(".counting-points") || elem.closest('.counting-points'))) {
        e.preventDefault();

        let bonus = Number(window.prompt("Set a bonus to this song (positive number)", ""));
        if (!isNaN(bonus)) {
          // optimist vision, the bonus is set correctly
          let points = elem.dataset["points"];
          elem.innerText = `${points} + ${bonus}`;
        }
      }
    });
  }

  _xhr_bonus() {
    var request = new XMLHttpRequest();
    request.open("POST", "/", true);
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
}
