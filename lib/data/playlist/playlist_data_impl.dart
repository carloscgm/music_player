import 'package:music_player/data/playlist/cache/playlist_cache_impl.dart';
import 'package:music_player/domain/playlist_repository.dart';
import 'package:music_player/model/playlist.dart';

class PlaylistDataImpl implements PlayListRepository {
  final PlayListCacheImpl _playListCacheImpl;
  PlaylistDataImpl(this._playListCacheImpl);

  @override
  Future<void> addPlaylist(PlayList playlist) {
    return _playListCacheImpl.addPlaylist(playlist);
  }

  @override
  Future<List<PlayList>> getPlaylist() {
    return _playListCacheImpl.getPlaylist();
  }

  @override
  Future<void> removePlaylist(PlayList playlist) {
    return _playListCacheImpl.removePlaylist(playlist);
  }
}
