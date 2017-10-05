import MyCloudinary from '../components/my-cloudinary';
import timeago from 'timeago.js';

export default class MainView {
  mount() {
    MyCloudinary.refresh();
    this.formatDate("time.date-format", {year: "numeric", month: "long"});
    this.formatNumber(".number");
    new timeago().render(document.querySelectorAll("time.timeago"));
  }
  umount() {
    MyCloudinary.disconnect();
  }

  formatNumber(selector) {
    var numberFormat = new Intl.NumberFormat();
    var els = document.querySelectorAll(selector);
    for (let i = 0; i < els.length; i++) {
        els[i].textContent = numberFormat.format(els[i].textContent);
    }
  }

  formatDate(selector, options) {
    // when undefined used the javascript local
    options.timeZone = "UTC";
    var dateTimeFormat = new Intl.DateTimeFormat(undefined, options);
    var elements = document.querySelectorAll(selector);

    // the date must be split, because parse the date in UTC and then apply the local timezone
    for (let i = 0; i < elements.length; i++) {
      let dateParts = elements[i].getAttribute("datetime").split("-");
      // month is 0 based...
      let datetime = new Date(Date.UTC(dateParts[0], dateParts[1] - 1, dateParts[2], 0, 0, 0));
      elements[i].textContent = dateTimeFormat.format(datetime);
    }
  }

}
