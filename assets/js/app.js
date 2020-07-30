// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"
import "tippy.js/dist/tippy.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import 'alpinejs'
import { LiveSocket } from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) { window.Alpine.clone(from.__x, to) }
    }
  },
  params: { _csrf_token: csrfToken }
})

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())


// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket

// Import local files
import "./helpers";
import loadView from "./views/loader";
import Pjax from "pjax-api";
import Radio from "./components/radio";
import Search from "./components/search";
import Opinions from "./components/opinions";
import OpinionPicker from "./components/opinionPicker";
import PlaylistPicker from "./components/playlistPicker";
import Carousel from "./components/carousel";
import Tippy from "tippy.js";
import "simplebar";
import "simplebar/dist/simplebar.css";

//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
function handleDOMContentLoaded() {
  // Get the current view name
  const viewName = document.getElementsByTagName("main")[0].dataset.jsViewName;
  console.log(`Loading ${viewName}`);

  // Load view class and mount it
  const ViewClass = loadView(viewName);
  const view = new ViewClass();
  view.mount();

  window.currentView = view;


  /* piwik */
  if (window._paq != null) {
    return _paq.push(["trackPageView"]);
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

document.addEventListener("DOMContentLoaded", handleDOMContentLoaded, false);
document.addEventListener("pjax:ready", handleDOMContentLoaded, false);
window.addEventListener("pjax:unload", handleUnloadContentLoaded, false);
window.addEventListener("scroll", () => Tippy.hideAllPoppers());

new Pjax({
  areas: ["body"],
  update: {
    css: false,
    js: false
  },
  filter: function (el) {
    return (
      el.matches(":not([target])") && el.matches(':not([data-pjax="false"])')
    );
  }
});