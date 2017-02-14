import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    // Specific logic here
    this._intlDate()

    console.log('TopIndexView mounted');
  }

  unmount() {
    super.unmount();

    // Specific logic here
    console.log('TopIndexView unmounted');
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
}
