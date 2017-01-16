//https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1


export default class MainView {
  mount() {
    // This will be executed when the document loads...
    console.log('MainView mounted');
    $("time.timeago").timeago();

  }

  unmount() {
    // This will be executed when the document unloads...
    console.log('MainView unmounted');
  }
}
