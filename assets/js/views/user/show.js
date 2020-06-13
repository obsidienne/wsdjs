import autolinkjs from 'autolink-js';
import MainView from '../main';
export default class View extends MainView {
  mount() {
    super.mount();

    // autolinks in comments
    var els = document.querySelectorAll(".aboutme");
    for (var i = 0; i < els.length; i++) {
      els[i].innerHTML = els[i].innerHTML.autoLink();
    }
  }
}