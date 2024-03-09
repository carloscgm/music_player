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
  late bool isFavorite;

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
    this.isFavorite = false,
  });

  //TODO: sacar imagenes de las canciones
  Widget getImage() {
    return const SizedBox(height: 330, width: 330, child: Placeholder());
  }

  setFavorite(bool isfav) {
    isFavorite = isfav;
  }

  String getTitle() {
    if (title.contains('.')) {
      return title.substring(0, title.lastIndexOf('.'));
    } else {
      return title;
    }
  }

  Song.fromMetadata(Metadata metadata) {
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
  }

  Song.fromData(String onlyTitle) {
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
  }
}
