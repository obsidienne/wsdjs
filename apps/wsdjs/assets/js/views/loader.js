import MainView    from './main';
import HomeIndexView from './home/index';
import SongShowView from './song/show';
import SongIndexView from './song/index';
import TopVotingView from './top/voting';
import TopCountingView from './top/counting';
import UserEditView from './user/edit';

// Collection of specific view modules
const views = {
  HomeIndexView,
  SongShowView,
  SongIndexView,
  TopVotingView,
  TopCountingView,
  UserEditView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
