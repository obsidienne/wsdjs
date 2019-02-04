import MainView from './main';
import SongShowView from './song/show';
import SongIndexView from './song/index';
import SongNewView from './song/new';
import Song_videosIndexView from './song_videos/index';
import Song_actionsEditView from './song_actions/edit';
import TopIndexView from './top/index';
import TopShowView from './top/show';
import UserEditView from './user/edit';
import UserShowView from './user/show';
import EventShowView from './event/show';
import EventNewView from './event/new';
import EventEditView from './event/edit';
import SuggestionNewView from './suggestion/new';

// Collection of specific view modules
const views = {
  SongShowView,
  SongIndexView,
  SongNewView,
  Song_videosIndexView,
  Song_actionsEditView,
  TopIndexView,
  TopShowView,
  UserEditView,
  UserShowView,
  EventNewView,
  EventEditView,
  EventShowView,
  SuggestionNewView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}