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

// Views
import User from './views/user.js';
import Home from './views/home.js';
import Song from './views/song.js';

function handleDOMContentLoaded() {
  // Get the current view name
  const viewName = document.getElementsByTagName('body')[0].dataset.jsViewName;

  // Load view class and mount it
  const ViewClass = loadView(viewName);
  const view = new ViewClass();
  view.mount();

  window.currentView = view;
}

var radio = new Radio();
var search = new Search();

// Views mounting
var user = new User();
var home = new Home();
var song = new Song();

window.addEventListener('turbolinks:load', handleDOMContentLoaded, false);
Turbolinks.start();
