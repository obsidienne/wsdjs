import MainView    from './main';
import SongShowView from './song/show';
import TopCountingView from './top/counting';
import UserEditView from './user/edit';

// Collection of specific view modules
const views = {
  SongShowView,
  TopCountingView,
  UserEditView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
