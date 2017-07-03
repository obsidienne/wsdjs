//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
import searchComponent from '../components/search';
import opinionComponent from '../components/opinion';
import cloudinary from 'cloudinary-core/cloudinary-core-shrinkwrap';
import Tippy from 'tippy.js/dist/tippy';
import Plyr from 'plyr/dist/plyr';

export default class MainView {
  constructor() {

  }

  // This will be executed when the document loads...
  mount() {
    new searchComponent().mount();
    new opinionComponent().mount();
    this._intlDate();
    this._intlNumber();
    this._loadImg();
    new Tippy('.tippy');

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

  _intlNumber() {
    var numberFormat = new Intl.NumberFormat();

    var elements = document.querySelectorAll(".number");
    for (let i = 0; i < elements.length; i++) {
      elements[i].textContent = numberFormat.format(elements[i].textContent);
    }
  }

  _loadImg() {
    var cl = cloudinary.Cloudinary.new();
    cl.init();
    cl.responsive();
  }
}
