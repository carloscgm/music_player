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
  });

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

  Song.fromData(String onlyTitle, int onlySize) {
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
    fileSize = onlySize;
  }
}
