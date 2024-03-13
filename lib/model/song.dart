import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metadata_god/metadata_god.dart';

class Song {
  late String title;
  late double? durationMs;
  late String? artist;
  late String? album;
  late String? albumArtist;
  late int? trackNumber;
  late int? trackTotal;
  late int? discNumber;
  late int? discTotal;
  late int? year;
  late String? genre;
  late Picture? picture;
  late int? fileSize;
  late String path;

  Song({
    required this.title,
    this.durationMs,
    this.artist,
    this.album,
    this.albumArtist,
    this.trackNumber,
    this.trackTotal,
    this.discNumber,
    this.discTotal,
    this.year,
    this.genre,
    this.picture,
    this.fileSize,
    required this.path,
  });

  String getArtist() {
    if (artist != null) {
      return artist!;
    } else {
      return '';
    }
  }

  //TODO: sacar imagenes de las canciones
  Widget getImage() {
    if (picture != null && picture!.data.isNotEmpty) {
      return Container(
        color: Colors.black,
        child: Image.memory(
          Uint8List.fromList(picture!.data),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const SizedBox(height: 330, width: 330, child: Placeholder());
    }
  }

  String getTitle() {
    if (title.contains('.')) {
      return title.substring(0, title.lastIndexOf('.'));
    } else {
      return title;
    }
  }

  Song.fromMetadata(Metadata metadata, String pathOfSong) {
    title = metadata.title!;
    durationMs = metadata.durationMs;
    artist = metadata.artist;
    album = metadata.album;
    albumArtist = metadata.albumArtist;
    trackNumber = metadata.trackNumber;
    trackTotal = metadata.trackTotal;
    discNumber = metadata.discNumber;
    discTotal = metadata.discTotal;
    year = metadata.year;
    genre = metadata.genre;
    picture = metadata.picture;
    fileSize = metadata.fileSize;
    path = pathOfSong;
  }

  Song.fromData(String onlyTitle, String pathOfSong) {
    title = onlyTitle;
    durationMs = 0.0;
    artist = '';
    album = '';
    albumArtist = '';
    trackNumber = 0;
    trackTotal = 0;
    discNumber = 0;
    discTotal = 0;
    year = 0;
    genre = '';
    picture = null;
    fileSize = 0;
    path = pathOfSong;
  }
}
