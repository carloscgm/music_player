import 'package:get_it/get_it.dart';
import 'package:music_player/data/artist/artist_data_impl.dart';
import 'package:music_player/data/artist/remote/artist_remote_impl.dart';
import 'package:music_player/data/remote/http_client.dart';
import 'package:music_player/data/song/local/song_local_impl.dart';
import 'package:music_player/data/song/song_data_impl.dart';
import 'package:music_player/domain/artist_repository.dart';
import 'package:music_player/domain/songs_repository.dart';
import 'package:music_player/presentation/view/artist/viewmodel/artist_view_model.dart';
import 'package:music_player/presentation/view/songs/viewmodel/songs_view_model.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupArtistModule();
    _setupSongsModule();
  }

  _setupMainModule() {
    inject.registerSingleton(HttpClient());
  }

  _setupArtistModule() {
    inject.registerFactory(() => ArtistRemoteImpl(inject.get()));
    inject
        .registerFactory<ArtistRepository>(() => ArtistDataImpl(inject.get()));
    inject.registerFactory(() => ArtistViewModel(inject.get()));
  }

  _setupSongsModule() {
    inject.registerFactory(() => SongLocalImpl());
    inject.registerFactory<SongsRepository>(() => SongDataImpl(inject.get()));
    inject.registerFactory(() => SongsViewModel(inject.get()));
  }
}
