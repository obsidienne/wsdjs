import MainView    from './main';
import SongShowView from './song/show';
import SongIndexView from './song/index';
import TopVotingView from './top/voting';
import TopCountingView from './top/counting';
import UserEditView from './user/edit';
import SongEditView from './song/edit';
import SongNewView from './song/new';

// Collection of specific view modules
const views = {
  SongShowView,
  SongIndexView,
  TopVotingView,
  TopCountingView,
  UserEditView,
  SongEditView,
  SongNewView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
