import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    this._voting();
    this._reset();
    this._submit();
    // Specific logic here
    console.log('TopVotingView mounted');
  }

  _submit() {
    var form = document.querySelector('#voting-form');
    form.addEventListener('submit', function(e) {
      var checked = document.querySelectorAll('input[type="checkbox"]:checked');
      if (checked.length == 10) {
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

  _reset() {
    var el = document.getElementById('voting-form');
    el.addEventListener('reset', function(e) {
      var elems = document.querySelectorAll('input[type="checkbox"]');
      Array.prototype.forEach.call(elems, function(el, i){
        el.value = 0;
      })

      var elems = document.querySelectorAll('.voting-position');
      Array.prototype.forEach.call(elems, function(el, i){ el.innerText = ""; });
    })
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
