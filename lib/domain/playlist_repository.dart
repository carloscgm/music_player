import 'package:music_player/model/playlist.dart';

abstract class PlayListRepository {
  Future<List<PlayList>> getPlaylist();
  Future<void> addPlaylist(PlayList playlist);
  Future<void> removePlaylist(PlayList playlist);
}
