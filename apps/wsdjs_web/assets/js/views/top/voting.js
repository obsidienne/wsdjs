import MainView from '../main';

export default class View extends MainView {
  constructor() {
    super();
    var self = this;

    document.addEventListener("change", function(e) {
      if (e.target && e.target.matches("#voting-form select")) {
        self._sort_on_vote();
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
  unmount() {}

  _sort_on_vote(e) {
    var parent = document.querySelector('.top-songs-container');

    // create an array from a querySelector
    Array.prototype.slice.call(parent.children)
    .sort(function(a, b) {
      // sort the nodes in the array
      var va = parseInt(a.querySelector("select").value);
      var vb = parseInt(b.querySelector("select").value);

      if (isNaN(va)) va = 999;
      if (isNaN(vb)) vb = 999;

      // if they are equals change position 
      if (va == vb) return -1;
      return va - vb;
    }).forEach(function(ele, i) {
      // Use the index in the array to set the select value.
      i += 1;
      if (i > 10) {
        ele.querySelector("select").value = "";
      } else {
        ele.querySelector("select").value = i;
      }
      parent.appendChild(ele);
    })
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
