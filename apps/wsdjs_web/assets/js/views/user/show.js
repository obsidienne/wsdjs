import Places from 'places.js/dist/cdn/places.js';

export default class View {
  mount() {
    var numberFormat = new Intl.NumberFormat();

    var els = document.querySelectorAll(".number");
    for (let i = 0; i < els.length; i++) {
      els[i].textContent = numberFormat.format(els[i].textContent);
    }
  }
}
