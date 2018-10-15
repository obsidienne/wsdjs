// We need to import the CSS so that webpack will load it.
// The ExtractTextPlugin is used to separate it out into
// its own CSS file.
import css from '../css/app.css';
import 'tippy.js/dist/tippy.css';

// webpack automatically concatenates all files in your
// watched paths. Those paths can be configured as
// endpoints in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket";

import './helpers';
import loadView from './views/loader';
import Pjax from 'pjax-api';
import Radio from './components/radio';
import Search from './components/search';
import Notifier from './components/notifier';
import Opinions from './components/opinions';
import OpinionPicker from './components/opinionPicker';
import PlaylistPicker from './components/playlistPicker';
import Tippy from 'tippy.js';

//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
function handleDOMContentLoaded() {
  // Get the current view name
  const viewName = document.getElementsByTagName('main')[0].dataset.jsViewName;
  console.log(`Loading ${viewName}`);

  // Load view class and mount it
  const ViewClass = loadView(viewName);
  const view = new ViewClass();
  view.mount();

  window.currentView = view;

  var notifier = new Notifier();
  notifier.show_all();

  /* piwik */
  if (window._paq != null) {
    return _paq.push(['trackPageView']);
  } else if (window.piwikTracker != null) {
    return piwikTracker.trackPageview();
  }

  Opinions.mount();
}

function handleUnloadContentLoaded() {
  if (window.currentView && window.currentView.unmount) {
    window.currentView.unmount();
  }
  Opinions.unmount();
}

var radio = new Radio();
var search = new Search();

document.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);
document.addEventListener('pjax:ready', handleDOMContentLoaded, false);
window.addEventListener('pjax:unload', handleUnloadContentLoaded, false);
window.addEventListener('scroll', () => Tippy.hideAllPoppers())

new Pjax({
  areas: [
    'main'
  ],
  update: {
    css: false,
    js: false
  },
  filter: function (el) {
    return el.matches(':not([target])') && el.matches(':not([pjax="false"])');
  }
});