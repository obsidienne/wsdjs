import MainView from './main';
import SongShowView from './song/show';
import SongIndexView from './song/index';
import SongEditView from './song/edit';
import SongNewView from './song/new';
import TopIndexView from './top/index';
import TopCountingView from './top/counting';
import TopVotingView from './top/voting';
import UserEditView from './user/edit';
import UserShowView from './user/show';
import HomeIndexView from './home/index';

// Collection of specific view modules
const views = {
  SongShowView,
  SongIndexView,
  SongNewView,
  SongEditView,
  TopIndexView,
  TopCountingView,
  TopVotingView,
  UserEditView,
  UserShowView,
  HomeIndexView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
