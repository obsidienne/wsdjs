import MainView from './main';
import SongShowView from './song/show';
import SongIndexView from './song/index';
import TopCountingView from './top/counting';
import UserEditView from './user/edit';
import HomeIndexView from './home/index';

// Collection of specific view modules
const views = {
  SongShowView,
  SongIndexView,
  TopCountingView,
  UserEditView,
  HomeIndexView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
