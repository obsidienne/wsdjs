import MainView    from './main';
import HottestIndexView from './hottest/index';
import TopIndexView from './top/index';
import TopShowView from './top/show';

// Collection of specific view modules
const views = {
  HottestIndexView,
  TopIndexView,
  TopShowView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
