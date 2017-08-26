import MainView from './main';
import SongShowView from './song/show';
import SongIndexView from './song/index';
import SongEditView from './song/edit';
import SongNewView from './song/new';
import TopIndexView from './top/index';
import TopCheckingView from './top/checking';
import TopCountingView from './top/counting';
import TopVotingView from './top/voting';
import TopPublishedView from './top/published';
import UserEditView from './user/edit';
import UserShowView from './user/show';
import UserIndexView from './user/index';
import HomeIndexView from './home/index';
import HomeUnauthenticatedView from './home/index';

// Collection of specific view modules
const views = {
  SongShowView,
  SongIndexView,
  SongNewView,
  SongEditView,
  TopIndexView,
  TopCheckingView,
  TopCountingView,
  TopVotingView,
  TopPublishedView,
  UserEditView,
  UserIndexView,
  UserShowView,
  HomeIndexView,
  HomeUnauthenticatedView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
