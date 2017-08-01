import CloudinaryCore from 'cloudinary-core/cloudinary-core-shrinkwrap';
import Tippy from 'tippy.js/dist/tippy';

export default class View {
  constructor() {
  }

  mount() { 
    // cloudinary
    var cl = CloudinaryCore.Cloudinary.new();
    cl.init();
    cl.responsive();

    // tooltip
    this.tips = new Tippy(".tippy[title]", {performance: true, size: "small", position: "top", appendTo: document.body});

    // intl date
    var options = {year: "numeric", month: "long"};
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);
    var elements = document.querySelectorAll("time");
    for (let i = 0; i < elements.length; i++) {
      let datetime = Date.parse(elements[i].getAttribute("datetime"))
      elements[i].textContent = dateTimeFormat.format(datetime);
    }
  }

  unmount() {
    this.tips.destroyAll();
  }
}