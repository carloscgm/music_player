import 'package:flutter/services.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:music_player/data/remote/error/remote_error_mapper.dart';
import 'package:music_player/model/song.dart';
import 'package:permission_handler/permission_handler.dart';

class SongLocalImpl {
  SongLocalImpl();

  Future<List<Song>> getSongs() async {
    try {
      String imagePath;
      try {
        imagePath = await StoragePath.imagesPath ?? 'nada';
      } on PlatformException {
        imagePath = 'Failed to get path';
      }
      print(imagePath);
      await Future.delayed(const Duration(seconds: 2));
      return mock;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<PermissionStatus> permissionStatus() async {
    return await Permission.audio.status;
  }
}

final mock = [
  Song(id: 1, title: 'Falling Away', algo: 'Breaking Benjamin'),
  Song(id: 2, title: 'Noches en BCN', algo: 'Zatu'),
  Song(id: 3, title: 'Efectos Vocales', algo: 'Nach'),
  Song(id: 4, title: 'The Diary of Jane', algo: 'Breaking Benjamin'),
  Song(id: 5, title: 'Sigo Buscándote', algo: 'Zatu'),
  Song(id: 6, title: 'Efectos Secundarios', algo: 'Nach'),
  Song(id: 7, title: 'I Will Not Bow', algo: 'Breaking Benjamin'),
  Song(id: 8, title: 'Estamos en Ello', algo: 'Zatu'),
  Song(id: 9, title: 'Efectos Especiales', algo: 'Nach'),
  Song(id: 10, title: 'Breath', algo: 'Breaking Benjamin'),
  Song(id: 11, title: 'Barcelona Nights', algo: 'Zatu'),
  Song(id: 12, title: 'Efectos Colaterales', algo: 'Nach'),
  Song(id: 13, title: 'So Cold', algo: 'Breaking Benjamin'),
  Song(id: 14, title: 'BCN Nocturno', algo: 'Zatu'),
  Song(id: 15, title: 'Efectos Adversos', algo: 'Nach'),
  Song(id: 16, title: 'Dance with the Devil', algo: 'Breaking Benjamin'),
  Song(id: 17, title: 'Caminando por Barcelona', algo: 'Zatu'),
  Song(id: 18, title: 'Efectos Secundarios (Remix)', algo: 'Nach'),
  Song(id: 19, title: 'Angels Fall', algo: 'Breaking Benjamin'),
  Song(id: 20, title: 'Amanecer en BCN', algo: 'Zatu'),
  Song(id: 21, title: 'Efectos Visuales', algo: 'Nach'),
  Song(id: 22, title: 'Torniquet', algo: 'Breaking Benjamin'),
  Song(id: 23, title: 'Luces de la Ciudad', algo: 'Zatu'),
];
