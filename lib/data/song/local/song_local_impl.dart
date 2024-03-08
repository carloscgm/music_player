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

  Future<List<Song>> getSongs() async {
    try {
      print('buscando');

      List<Song> result = [];
      List<String> typeToSearch = [];
      List<String> sources = await ExternalPath.getExternalStorageDirectories();

      for (var typeElement in typeToSearchMaster) {
        typeToSearch.add(
            await ExternalPath.getExternalStoragePublicDirectory(typeElement));
        for (int i = 1; i < sources.length; i++) {
          typeToSearch.add(
              (await ExternalPath.getExternalStoragePublicDirectory(
                      typeElement))
                  .replaceAll(sources[0], sources[i]));
        }
      }

      typeToSearch.forEach((path) async {
        Directory dir = Directory(path);
        dir.list(recursive: true).forEach((element) async {
          if (element.path.endsWith('mp3')) {
            print(' desde aqui [${element.path}]');
            try {
              Metadata metadata =
                  await MetadataGod.readMetadata(file: element.path);
              result.add(Song.fromMetadata(metadata));
            } on Exception catch (_, __) {
              result.add(Song.fromData(
                  element.path.substring(element.path.lastIndexOf('/') + 1),
                  (await File(element.path).stat()).size));
            }
          }
        });
      });

      return result;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<PermissionStatus> permissionStatus() async {
    return await Permission.audio.status;
  }
}
