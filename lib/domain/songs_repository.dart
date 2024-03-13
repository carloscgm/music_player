import 'package:music_player/model/song.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class SongsRepository {
  Future<List<Song>> getSongs();
  Future<PermissionStatus> permissionStatus();
  Future<Song> getSongByPath(String path);
}
