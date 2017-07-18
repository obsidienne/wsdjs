import MainView    from './main';
import SongShowView from './song/show';
import SongIndexView from './song/index';
import TopVotingView from './top/voting';
import TopCountingView from './top/counting';
import UserEditView from './user/edit';

// Collection of specific view modules
const views = {
  SongShowView,
  SongIndexView,
  TopVotingView,
  TopCountingView,
  UserEditView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
