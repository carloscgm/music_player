import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/domain/player_repository.dart';
import 'package:music_player/domain/playlist_repository.dart';
import 'package:music_player/domain/songs_repository.dart';
import 'package:music_player/model/song.dart';

class PlayerServices implements PlayerRepository {
  SongsRepository songsRepository;
  PlayListRepository playListRepository;
  late AudioPlayer audioPlayer;
  late Song currentSong;
  PlayerServices(this.songsRepository, this.playListRepository);

  @override
  void dispose() {
    audioPlayer.dispose();
  }

  @override
  void initPlayer() {
    audioPlayer = AudioPlayer();
  }

  @override
  void initPlay(Song song) {
    currentSong = song;
    audioPlayer.play(DeviceFileSource(song.path));
  }


  void dale () async {
    Uint8List bytes = await File(currentSong.path).readAsBytes();
    print()
  }

  @override
  Future<void> nextSong() {
    // TODO: implement nextSong
    throw UnimplementedError();
  }

  @override
  void pausePlay() {
    if (audioPlayer.state == PlayerState.playing) {
      audioPlayer.pause();
    } else if (audioPlayer.state == PlayerState.completed) {
      audioPlayer.play(DeviceFileSource(currentSong.path));
    } else {
      audioPlayer.resume();
    }
  }

  @override
  Future<void> previousSong() {
    // TODO: implement previousSong
    throw UnimplementedError();
  }

  @override
  Future<void> seekNext10() async {
    Duration newPosition = Duration(
        seconds: (await audioPlayer.getCurrentPosition())!.inSeconds + 10);
    audioPlayer.seek(newPosition);
  }

  @override
  void seekPercent(double newPosition) async {
    Duration newDuration = Duration(
        seconds: ((await audioPlayer.getDuration())!.inSeconds * newPosition)
            .floor());
    audioPlayer.seek(newDuration);
  }

  @override
  Future<void> seekPrevious10() async {
    Duration newPosition = Duration(
        seconds: (await audioPlayer.getCurrentPosition())!.inSeconds - 10);
    audioPlayer.seek(newPosition);
  }
}
