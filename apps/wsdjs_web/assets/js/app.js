// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"


import "phoenix_html"
import loadView from './views/loader';
import Turbolinks from 'turbolinks';
import Radio from './components/radio';
import Search from './components/search';
import Notifier from './components/notifier';
import Tabs from './components/tabs';

//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
function handleDOMContentLoaded() {
  // Get the current view name
  const viewName = document.getElementsByTagName('body')[0].dataset.jsViewName;

  // Load view class and mount it
  const ViewClass = loadView(viewName);
  const view = new ViewClass();
  view.mount();

  window.currentView = view;

  var notifier = new Notifier();
  notifier.show_all();

  /* set the current volume radio */
  var volumeElement = document.getElementById("player__volume");
  if (volumeElement.getAttribute("value") == null) {
    volumeElement.setAttribute("value", 0.5);    
    radio.setVolume(0.5);
  }

  /* piwik */
  if (window._paq != null) {
    return _paq.push(['trackPageView']);
  } else if (window.piwikTracker != null) {
    return piwikTracker.trackPageview();
  }
}

function handleUnloadContentLoaded() {
  window.currentView.unmount();
}

var radio = new Radio();
var search = new Search();

window.addEventListener('turbolinks:load', handleDOMContentLoaded, false);
window.addEventListener('turbolinks:before-cache', handleUnloadContentLoaded, false);
Turbolinks.start();
