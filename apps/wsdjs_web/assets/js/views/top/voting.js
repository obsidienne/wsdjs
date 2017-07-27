export default class View {
  mount() {
    super.mount();

    this._voting();
    this._submit();
    // Specific logic here
    console.log('TopVotingView mounted');
  }

  _submit() {
    var form = document.querySelector('#voting-form');
    form.addEventListener('submit', function(e) {
      var values = document.querySelectorAll('#voting-form select');
      
      var qty = 0;
      var sum = 0;
      for (var i = 0; i < values.length; ++i) {
        if (values[i].value > 0) {
          sum +=  parseInt(values[i].value);
          qty += 1;
        }
      }

      console.log(`${qty} - ${sum}`)
      if (sum == 55 && qty == 10) {
        console.log("Send to the server the vote.");
        return true;
      }
      e.preventDefault();
      return false;
    })
  }

  _voting() {
    var elems = document.querySelectorAll('input[type="checkbox"]');
    var self = this;

    Array.prototype.forEach.call(elems, function(el, i){
      el.addEventListener('change', function(e) {
        if (el.checked) {
          var checked = document.querySelectorAll('input[type="checkbox"]:checked');
          if (checked.length > 10) {
            el.checked = false;
            return;
          }

          el.value = checked.length;
          var div = e.target.parentNode.querySelector('.voting-position')
          div.innerHTML = `<div class="chart-bg"></div><div class="chart-value">${el.value}</div>`;
        } else {
          self._dec_charts(parseInt(el.value));

          var div = e.target.parentNode.querySelector('.voting-position')
          div.innerText = "";
          el.value = 0;
        }
      });
    });
  }

  _dec_charts(value) {
    var elems = document.querySelectorAll('input[type="checkbox"]:checked');
    Array.prototype.forEach.call(elems, function(el, i){
      var new_value = parseInt(el.value);
      if (new_value > value) {
        el.value = new_value - 1;
        var div = el.parentNode.querySelector('.voting-position')
        div.innerHTML = `<div class="chart-bg"></div><div class="chart-value">${el.value}</div>`;
      }
    })
  }
}
