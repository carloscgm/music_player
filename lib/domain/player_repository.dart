import 'package:music_player/model/song.dart';

abstract class PlayerRepository {
  void initPlayer();
  void pausePlay();
  void initPlay(Song song);
  Future<void> seekNext10();
  void seekPercent(double newPosition);
  Future<void> seekPrevious10();
  void dispose();
}
