import 'package:music_player/model/playlist.dart';
import 'package:music_player/model/song.dart';

abstract class PlayListRepository {
  Future<List<PlayList>> getPlaylist();
  Future<void> addPlaylist(PlayList playlist);
  Future<void> removePlaylist(PlayList playlist);
  Future<List<Song>> getSongsByPlaylist(PlayList playlist);
}
