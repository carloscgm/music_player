import 'dart:async';

import 'package:music_player/domain/songs_repository.dart';
import 'package:music_player/presentation/common/base/base_view_model.dart';
import 'package:music_player/presentation/common/base/resource_state.dart';
import 'package:music_player/presentation/common/errorhandling/app_action.dart';
import 'package:music_player/presentation/view/songs/viewmodel/songs_error_builder.dart';

class SongsViewModel extends BaseViewModel {
  final SongsRepository _songsRepository;

  SongsViewModel(this._songsRepository);

  StreamController<ResourceState> songsListState =
      StreamController<ResourceState>();
  StreamController<ResourceState> permissionState =
      StreamController<ResourceState>();

  Future<void> fetchSongs() async {
    songsListState.add(ResourceState.loading());

    _songsRepository
        .getSongs()
        .then((value) => songsListState.add(ResourceState.completed(value)))
        .catchError((e) {
      songsListState.add(ResourceState.error(
          SongsErrorBuilder.create(e, AppAction.GET_SONGS).build()));
    });
  }

  Future<void> permissionStatus() async {
    permissionState.add(ResourceState.loading());

    _songsRepository
        .permissionStatus()
        .then((value) => permissionState.add(ResourceState.completed(value)))
        .catchError((e) {
      permissionState.add(ResourceState.error(
          SongsErrorBuilder.create(e, AppAction.GET_SONGS).build()));
    });
  }

  @override
  void dispose() {
    songsListState.close();
  }
}
