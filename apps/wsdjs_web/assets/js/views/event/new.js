import MainView from '../main';
import Notifier from '../../components/notifier';

export default class View extends MainView {
  constructor() {
    super();
  }

  mount() {
    super.mount();
    places({
      container: document.querySelector('.search-place')
    })
  }
}
