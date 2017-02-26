import MainView    from './main';
import HottestIndexView from './hottest/index';
import SongShowView from './song/show';

// Collection of specific view modules
const views = {
  HottestIndexView,
  SongShowView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
