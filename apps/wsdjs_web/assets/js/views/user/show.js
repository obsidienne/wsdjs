import Places from 'places.js/dist/cdn/places.js';
import MainView from '../main';

import Tippy from 'tippy.js/dist/tippy.all';

export default class View extends MainView {
  constructor() {
    super();
  }

  mount() {
    super.mount();
    this.tips = new Tippy(".tippy[title]", {performance: true});
  }
  unmount() { 
    super.umount();
    this.tips.destroyAll();
  }
}
