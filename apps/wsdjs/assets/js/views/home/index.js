import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    this._intlDate();

    // Specific logic here
    console.log('HomeIndexView mounted');
  }

  _intlDate() {
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);

    var elements = document.querySelectorAll("time:not(.timeago)");
    for (let i = 0; i < elements.length; i++) {
      let datetime = Date.parse(elements[i].getAttribute("datetime"))
      elements[i].textContent = dateTimeFormat.format(datetime);
    }
  }
}
