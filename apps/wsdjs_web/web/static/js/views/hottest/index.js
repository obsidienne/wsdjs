import timeago from 'timeago.js';
import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    new timeago().render(document.querySelectorAll("time.timeago"));
    // Specific logic here
    console.log('HottestIndexView mounted');
  }

  unmount() {
    super.unmount();

    // Specific logic here
    console.log('HottestIndexView unmounted');
  }

}
