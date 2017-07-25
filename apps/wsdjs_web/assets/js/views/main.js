//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
import Notifier from '../components/notifier';
import timeago from 'timeago.js';

export default class MainView {
  // This will be executed when the document loads...
  mount() {
    this._intlDate();
    this._intlNumber();
  }
  
  _intlDate() {
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);

    var elements = document.querySelectorAll("time");
    for (let i = 0; i < elements.length; i++) {
      let datetime = Date.parse(elements[i].getAttribute("datetime"))
      elements[i].textContent = dateTimeFormat.format(datetime);
    }
  }

  _intlNumber() {
    var numberFormat = new Intl.NumberFormat();

    var elements = document.querySelectorAll(".number");
    for (let i = 0; i < elements.length; i++) {
      elements[i].textContent = numberFormat.format(elements[i].textContent);
    }
  }
}
