import MainView    from './main';
import HottestIndexView from './hottest/index';

// Collection of specific view modules
const views = {
  HottestIndexView,
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
