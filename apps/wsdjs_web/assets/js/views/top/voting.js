import MainView from '../main';

export default class View extends MainView {
  constructor() {
    super();
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

}
