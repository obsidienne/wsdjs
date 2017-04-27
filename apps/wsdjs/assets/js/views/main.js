//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
import searchComponent from '../components/search';
import opinionComponent from '../components/opinion';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';

export default class MainView {
  constructor() {
    this.cl = cloudinary.Cloudinary.new();
    this.cl.init();
  }

  // This will be executed when the document loads...
  mount() {
    new searchComponent().mount(this.cl);
    new opinionComponent().mount();
    this._intlDate()
    this._loadImg();

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
