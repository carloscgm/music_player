import 'package:music_player/data/cache/database_tables.dart';
import 'package:music_player/data/cache/error/cache_error_mapper.dart';
import 'package:music_player/data/cache/playlist_database_helper.dart';
import 'package:music_player/model/playlist.dart';

class PlayListCacheImpl {
  final PlayListDatabaseHelper _playlistDatabaseHelper;

  PlayListCacheImpl(this._playlistDatabaseHelper);

  Future<List<PlayList>> getPlaylist() async {
    try {
      return (await _playlistDatabaseHelper.getAll(DatabaseTables.playlist))
          .map((e) => PlayList.fromJson(e))
          .toList();
    } catch (e) {
      throw CacheErrorMapper.getException(e);
    }
  }

  Future<void> addPlaylist(PlayList playlist) async {
    try {
      await _playlistDatabaseHelper.insert(
          DatabaseTables.playlist, playlist.toJson());
    } catch (e) {
      throw CacheErrorMapper.getException(e);
    }
  }

  Future<void> removePlaylist(PlayList playlist) async {
    try {
      await _playlistDatabaseHelper.delete(
          DatabaseTables.playlist, MapEntry('id', playlist.id));
    } catch (e) {
      throw CacheErrorMapper.getException(e);
    }
  }
}
