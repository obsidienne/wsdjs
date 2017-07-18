import MainView    from './main';
import SongShowView from './song/show';
import TopVotingView from './top/voting';
import TopCountingView from './top/counting';
import UserEditView from './user/edit';

// Collection of specific view modules
const views = {
  SongShowView,
  TopVotingView,
  TopCountingView,
  UserEditView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
