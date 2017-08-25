import timeago from 'timeago.js';
import MainView from '../main';

export default class View extends MainView {
  constructor() {
    super();
  }

  mount() {
    new timeago().render(document.querySelectorAll("time.timeago"));
  }
}
