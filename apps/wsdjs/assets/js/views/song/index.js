import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    window.addEventListener("scroll", event => this._refresh(event));


    console.log('SongIndexView mounted');
  }

  _refresh(event) {
    var pageHeight = document.documentElement.scrollHeight;
    var clientHeight = document.documentElement.clientHeight;
    var scrollPos = window.pageYOffset;

    var remaining = pageHeight - (scrollPos + clientHeight)
    console.log(`${pageHeight} - (${scrollPos} + ${clientHeight}) = ${remaining}`);
    if (remaining < 150) {
      console.log("scroll bottom: need refresh");
    } else {
      console.log("scroll, nothing to do");
    }

  }
}
