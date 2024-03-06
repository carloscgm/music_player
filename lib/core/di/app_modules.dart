import 'package:music_player/data/artist/artist_data_impl.dart';
import 'package:music_player/data/artist/remote/artist_remote_impl.dart';
import 'package:music_player/data/remote/http_client.dart';
import 'package:music_player/domain/artist_repository.dart';
import 'package:music_player/presentation/view/artist/viewmodel/artist_view_model.dart';
import 'package:get_it/get_it.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupArtistModule();
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
}
