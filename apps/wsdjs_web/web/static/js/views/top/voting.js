import Sortable from 'sortablejs';
import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    this._sortableSongs();
    // Specific logic here
    console.log('TopVotingView mounted');
  }

  unmount() {
    super.unmount();

    // Specific logic here
    console.log('TopVotingView unmounted');
  }

  _sortableSongs() {
    var source = document.getElementById('voting-songs-source');
    Sortable.create(source, {group: "voting"});

    var target = document.getElementById('voting-songs-target');
    Sortable.create(target, {group: "voting"});
  }
}
