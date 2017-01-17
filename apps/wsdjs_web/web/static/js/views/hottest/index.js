import $ from 'jquery';
import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    $("time.timeago").timeago();

    // Specific logic here
    console.log('PageNewView mounted');
  }

  unmount() {
    super.unmount();

    // Specific logic here
    console.log('PageNewView unmounted');
  }

}
