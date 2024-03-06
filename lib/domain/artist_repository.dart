import 'package:music_player/model/artist.dart';

abstract class ArtistRepository {
  Future<List<Artist>> getArtists();
}
