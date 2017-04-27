import timeago from 'timeago.js';
import autolinkjs from 'autolink-js';
import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    new timeago().render(document.querySelectorAll("time.timeago"));
    this._intlDate();
    //this._set_opinion();

    // Specific logic here
    console.log('SongIndexView mounted');
  }

  _intlDate() {
    var elements = document.querySelectorAll(".comment-content");

    Array.prototype.forEach.call(elements, function(el, i) {
        el.innerHTML = el.innerHTML.autoLink();
    });
  }
}
