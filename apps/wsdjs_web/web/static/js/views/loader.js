import MainView    from './main';
import HottestIndexView from './hottest/index';
import SongShowView from './song/show';
import TopVotingView from './top/voting';

// Collection of specific view modules
const views = {
  HottestIndexView,
  SongShowView,
  TopVotingView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
