import 'package:get_it/get_it.dart';
import 'package:music_player/data/local/cache/playlist_database_helper.dart';
import 'package:music_player/data/local/local_impl.dart';
import 'package:music_player/data/playlist/cache/playlist_cache_impl.dart';
import 'package:music_player/data/playlist/playlist_data_impl.dart';
import 'package:music_player/data/remote/http_client.dart';
import 'package:music_player/data/song/song_data_impl.dart';
import 'package:music_player/domain/playlist_repository.dart';
import 'package:music_player/domain/songs_repository.dart';
import 'package:music_player/presentation/view/playlist/viewmodel/playlist_view_model.dart';
import 'package:music_player/presentation/view/songs/viewmodel/songs_view_model.dart';
import 'package:music_player/service/player/player_services.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupSongsModule();
    _setupPlayListModule();
    _setupPlayerModule();
  }

  _setupMainModule() {
    inject.registerSingleton(HttpClient());
    inject.registerSingleton(PlayListDatabaseHelper());
    inject.registerFactory(() => LocalImpl());
  }

  _setupSongsModule() {
    inject.registerFactory<SongsRepository>(() => SongDataImpl(inject.get()));
    inject.registerFactory(() => SongsViewModel(inject.get()));
  }

  _setupPlayListModule() {
    inject.registerFactory(() => PlayListCacheImpl(inject.get(), inject.get()));
    inject.registerFactory<PlayListRepository>(
        () => PlaylistDataImpl(inject.get()));
    inject.registerFactory(() => PlayListViewModel(inject.get()));
  }

  _setupPlayerModule() {
    inject.registerFactory(() => PlayerServices(inject.get()));
  }
}
