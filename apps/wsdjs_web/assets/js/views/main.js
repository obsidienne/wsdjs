export default class MainView {
  mount() {
    this.formatNumber(".number");
  }
  umount() { }

  formatNumber(selector) {
    var numberFormat = new Intl.NumberFormat();
    var els = document.querySelectorAll(selector);
    for (let i = 0; i < els.length; i++) {
        els[i].textContent = numberFormat.format(els[i].textContent);
    }
  }
}
