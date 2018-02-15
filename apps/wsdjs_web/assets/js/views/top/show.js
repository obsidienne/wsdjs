import MainView from '../main';
import Tippy from 'tippy.js/dist/tippy.all';

export default class View extends MainView {
  constructor() {
    super();
    this._bonus();
    
    var self = this;

    document.addEventListener("change", function(e) {
      if (e.target && e.target.matches("#voting-form select")) {
        self._sort_on_vote(e);
      }      
    }, false);

    document.addEventListener("submit", function(e) {
      if (e.target && e.target.matches("#voting-form")) {
        self._submit(e);
      }
    }, false);
  }

  mount() {
    super.mount();
    this.tips = new Tippy(".tippy[title]", {performance: true});
  }
  unmount() {
    super.umount();
    this.tips.destroyAll();
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

  _sort_on_vote(e) {
    let parent = document.querySelector('.top-songs-container');
    let song = e.target.closest(".top-song");
    let position = parseInt(e.target.value);
    
    let elem = parent.removeChild(song);

    parent.insertBefore(elem, parent.children[position - 1])

    /* set the position in a data */
    for(let i = 0; i < parent.children.length; i++) {
      if (i + 1 > 10) {
        parent.children[i].querySelector("select").value = '';
      }
      parent.children[i].querySelector("select").value = i + 1;
    }
  }

  _submit(e) {
    var values = document.querySelectorAll('#voting-form select');
    
    var qty = 0;
    var sum = 0;
    for (var i = 0; i < values.length; ++i) {
      if (values[i].value > 0) {
        sum +=  parseInt(values[i].value);
        qty += 1;
      }
    }

    if (sum == 55 && qty == 10) {
      return true;
    }
    e.preventDefault();
    return false;
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
