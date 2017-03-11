//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
import glMenubar from './shared/gl_menubar';
import glSearch from './shared/gl_search';
import Radio from './shared/radio';
import Turbolinks from 'turbolinks';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class MainView {
  constructor() {
    this.cl = cloudinary.Cloudinary.new();
    this.cl.init();
  }

  // This will be executed when the document loads...
  mount() {
    new glMenubar().mount();
    new glSearch().mount(this.cl);
    new Radio().mount();
    this._intlDate()

    this._loadImg();

    Turbolinks.start()

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

  _loadImg() {
    this.cl.responsive();
  }
}
