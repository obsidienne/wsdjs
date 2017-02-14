//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
import glMenubar from './shared/gl_menubar';
import glSearch from './shared/gl_search';
import UJS from "phoenix_ujs";

export default class MainView {
  // This will be executed when the document loads...
  mount() {
    new glMenubar().mount();
    new glSearch().mount();
    console.log('MainView mounted');
  }

  unmount() {
    // This will be executed when the document unloads...
    console.log('MainView unmounted');
  }
}
