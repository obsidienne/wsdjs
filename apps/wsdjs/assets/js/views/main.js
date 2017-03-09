//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
import glMenubar from './shared/gl_menubar';
import glSearch from './shared/gl_search';

export default class MainView {
  // This will be executed when the document loads...
  mount() {
    new glMenubar().mount();
    new glSearch().mount();
    this._intlDate()

    console.log('MainView mounted');
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
