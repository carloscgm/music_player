import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:music_player/data/remote/error/remote_error_mapper.dart';
import 'package:music_player/model/song.dart';
import 'package:permission_handler/permission_handler.dart';

class SongLocalImpl {
  SongLocalImpl();

  final List<String> typeToSearchMaster = [
    ExternalPath.DIRECTORY_DOWNLOADS,
    ExternalPath.DIRECTORY_AUDIOBOOKS,
    ExternalPath.DIRECTORY_MUSIC,
    ExternalPath.DIRECTORY_PODCASTS
  ];

  Future<Song> getSongByPath(String path) async {
    try {
      Metadata metadata = await MetadataGod.readMetadata(file: path);
      return Song.fromMetadata(metadata, path);
    } on Exception catch (_, __) {
      return Song.fromData(path.substring(path.lastIndexOf('/') + 1), path);
    }
  }

  Future<List<String>> getSources(List<String> sources) async {
    List<String> typeToSearch = [];
    for (var typeElement in typeToSearchMaster) {
      typeToSearch.add(
          await ExternalPath.getExternalStoragePublicDirectory(typeElement));
      for (int i = 1; i < sources.length; i++) {
        typeToSearch.add(
            (await ExternalPath.getExternalStoragePublicDirectory(typeElement))
                .replaceAll(sources[0], sources[i]));
      }
    }
    return typeToSearch;
  }

  Future<List<Song>> getSongsByDirs(List<String> typeToSearch) async {
    List<Song> result = [];

    for (int i = 0; i < typeToSearch.length; i++) {
      Directory dir = Directory(typeToSearch[i]);
      List<FileSystemEntity> listita = dir.listSync(recursive: true);
      for (int j = 0; j < listita.length; j++) {
        if (listita[j].path.endsWith('mp3')) {
          try {
            Metadata metadata =
                await MetadataGod.readMetadata(file: listita[j].path);
            result.add(Song.fromMetadata(metadata, listita[j].path));
          } on Exception catch (_, __) {
            result.add(Song.fromData(
                listita[j].path.substring(listita[j].path.lastIndexOf('/') + 1),
                listita[j].path));
          }
        }
      }
    }
    return result;
  }

  Future<List<Song>> getSongs() async {
    try {
      List<String> sources = await ExternalPath.getExternalStorageDirectories();
      List<String> typeToSearch = await getSources(sources);

      List<Song> result = await getSongsByDirs(typeToSearch);
      return result;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<PermissionStatus> permissionStatus() async {
    return await Permission.audio.status;
  }
}
