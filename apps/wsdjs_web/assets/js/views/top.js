
export default class Top {
  constructor() {
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

    console.log('TopVotingView mounted');
  }

  _sort_on_vote(e) {
    console.log(e);
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
