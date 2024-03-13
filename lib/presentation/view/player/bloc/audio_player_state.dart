// ignore_for_file: must_be_immutable

part of 'audio_player_bloc.dart';

class AudioPlayerState extends Equatable {
  AudioPlayer audioplayer;
  Song currentSong;
  PlayList? playlist;
  late Duration currentDuration;
  late Duration? finalDuration;

  AudioPlayerState(
      {required this.audioplayer, required this.currentSong, this.playlist}) {
    currentDuration = audioplayer.position;
    finalDuration = audioplayer.duration;
  }

  @override
  List<Object?> get props => [
        audioplayer,
        audioplayer.playing,
        currentSong,
        playlist,
        currentDuration,
        finalDuration
      ];

  AudioPlayerState copyWith({
    AudioPlayer? audioplayer,
    Song? currentSong,
    PlayList? playlist,
  }) {
    return AudioPlayerState(
      audioplayer: audioplayer ?? this.audioplayer,
      currentSong: currentSong ?? this.currentSong,
      playlist: playlist ?? this.playlist,
    );
  }
}
