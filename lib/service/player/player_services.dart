import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/domain/player_repository.dart';
import 'package:music_player/domain/songs_repository.dart';
import 'package:music_player/model/song.dart';

class PlayerServices implements PlayerRepository {
  SongsRepository songsRepository;
  late AudioPlayer audioPlayer;
  Song? currentSong;
  PlayerServices(this.songsRepository);

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

  @override
  void pausePlay() {
    if (audioPlayer.state == PlayerState.playing) {
      audioPlayer.pause();
    } else if (audioPlayer.state == PlayerState.completed) {
      audioPlayer.play(DeviceFileSource(currentSong!.path));
    } else {
      audioPlayer.resume();
    }
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
