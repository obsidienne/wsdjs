import MainView from '../main';

export default class View extends MainView {
  mount() {
    var numberFormat = new Intl.NumberFormat();

    var els = document.querySelectorAll(".number");
    for (let i = 0; i < els.length; i++) {
        els[i].textContent = numberFormat.format(els[i].textContent);
    }

    // intl date
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);
    var elements = document.querySelectorAll("time");
    for (let i = 0; i < elements.length; i++) {
        let datetime = Date.parse(elements[i].getAttribute("datetime"))
        elements[i].textContent = dateTimeFormat.format(datetime);
    }
    super.mount();
  }
}
