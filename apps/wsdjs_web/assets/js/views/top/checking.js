import timeago from 'timeago.js';
import MainView from '../main';

export default class View extends MainView {
  constructor() {
    super();
  }

  mount() {
    new timeago().render(document.querySelectorAll("time.timeago"));
    this._intlTopDate();
  }

  _intlTopDate() {
    // intl date
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);
    var elements = document.querySelectorAll("time");
    for (let i = 0; i < elements.length; i++) {
      let datetime = Date.parse(elements[i].getAttribute("datetime"))
      elements[i].textContent = dateTimeFormat.format(datetime);
    }
  }
}
