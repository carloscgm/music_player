import 'dart:async';

import 'package:music_player/domain/playlist_repository.dart';
import 'package:music_player/model/playlist.dart';
import 'package:music_player/presentation/common/base/base_view_model.dart';
import 'package:music_player/presentation/common/base/resource_state.dart';
import 'package:music_player/presentation/common/errorhandling/app_action.dart';
import 'package:music_player/presentation/view/playlist/viewmodel/playlist_error_builder.dart';

class PlayListViewModel extends BaseViewModel {
  final PlayListRepository _playlistRepository;

  PlayListViewModel(this._playlistRepository);

  StreamController<ResourceState> playlistListState =
      StreamController<ResourceState>();
  StreamController<ResourceState> addPlaylistState =
      StreamController<ResourceState>();
  StreamController<ResourceState> removePlaylistState =
      StreamController<ResourceState>();
  StreamController<ResourceState> getSongsByPlaylistState =
      StreamController<ResourceState>();

  Future<void> getSongsByPlaylist(PlayList playlist) async {
    getSongsByPlaylistState.add(ResourceState.loading());

    _playlistRepository
        .getSongsByPlaylist(playlist)
        .then((value) =>
            getSongsByPlaylistState.add(ResourceState.completed(value)))
        .catchError((e) {
      getSongsByPlaylistState.add(ResourceState.error(
          PlayListErrorBuilder.create(e, AppAction.GET_SONGS_BY_PLAYLIST)
              .build()));
    });
  }

  Future<void> fetchPlayList() async {
    playlistListState.add(ResourceState.loading());

    _playlistRepository
        .getPlaylist()
        .then((value) => playlistListState.add(ResourceState.completed(value)))
        .catchError((e) {
      playlistListState.add(ResourceState.error(
          PlayListErrorBuilder.create(e, AppAction.GET_PLAYLIST).build()));
    });
  }

  Future<void> addPlayList(PlayList playlist) async {
    addPlaylistState.add(ResourceState.loading());

    _playlistRepository
        .addPlaylist(playlist)
        .then((value) => addPlaylistState.add(ResourceState.completed(null)))
        .catchError((e) {
      addPlaylistState.add(ResourceState.error(
          PlayListErrorBuilder.create(e, AppAction.ADD_PLAYLIST).build()));
    });
  }

  Future<void> removePlayList(PlayList playlist) async {
    removePlaylistState.add(ResourceState.loading());

    _playlistRepository
        .removePlaylist(playlist)
        .then((value) => removePlaylistState.add(ResourceState.completed(null)))
        .catchError((e) {
      removePlaylistState.add(ResourceState.error(
          PlayListErrorBuilder.create(e, AppAction.REMOVE_PLAYLIST).build()));
    });
  }

  @override
  void dispose() {
    playlistListState.close();
    addPlaylistState.close();
    removePlaylistState.close();
  }
}
