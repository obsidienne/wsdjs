import timeago from 'timeago.js';
import MainView from '../main';
import Modal from 'modal-vanilla';

export default class View extends MainView {
  mount() {
    super.mount();

    new timeago().render(document.querySelectorAll("time.timeago"));
    this._intlDate();

    document.querySelector('.js-static-modal-toggle')
      .addEventListener('click', function() {
        new Modal({el: document.getElementById('static-modal')}).show();
      });

    // Specific logic here
    console.log('HottestIndexView mounted');
  }

  unmount() {
    super.unmount();

    // Specific logic here
    console.log('HottestIndexView unmounted');
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
