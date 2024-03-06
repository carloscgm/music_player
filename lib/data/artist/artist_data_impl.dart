import 'package:music_player/data/artist/remote/artist_remote_impl.dart';
import 'package:music_player/domain/artist_repository.dart';
import 'package:music_player/model/artist.dart';

class ArtistDataImpl implements ArtistRepository {
  final ArtistRemoteImpl _remoteImpl;
  ArtistDataImpl(this._remoteImpl);

  @override
  Future<List<Artist>> getArtists() {
    return _remoteImpl.getArtists();
  }
}
