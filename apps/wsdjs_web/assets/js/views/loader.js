import MainView from './main';
import SongShowView from './song/show';
import SongIndexView from './song/index';
import SongEditView from './song/edit';
import SongNewView from './song/new';
import TopIndexView from './top/index';
import TopShowView from './top/show';
import UserEditView from './user/edit';
import EventNewView from './event/new';
import SuggestionNewView from './suggestion/new';

// Collection of specific view modules
const views = {
  SongShowView,
  SongIndexView,
  SongNewView,
  SongEditView,
  TopIndexView,
  TopShowView,
  UserEditView,
  EventNewView,
  SuggestionNewView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}