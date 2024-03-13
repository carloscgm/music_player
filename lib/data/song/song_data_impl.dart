import 'package:music_player/data/song/local/song_local_impl.dart';
import 'package:music_player/domain/songs_repository.dart';
import 'package:music_player/model/song.dart';
import 'package:permission_handler/permission_handler.dart';

class SongDataImpl implements SongsRepository {
  final SongLocalImpl _localImpl;
  SongDataImpl(this._localImpl);

  @override
  Future<List<Song>> getSongs() {
    return _localImpl.getSongs();
  }

  @override
  Future<Song> getSongByPath(String path) {
    return _localImpl.getSongByPath(path);
  }

  @override
  Future<PermissionStatus> permissionStatus() {
    return _localImpl.permissionStatus();
  }
}
