part of 'audio_player_bloc.dart';

class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();

  @override
  List<Object> get props => [];
}

class AudioPlayerInit extends AudioPlayerEvent {
  final String songPath;

  const AudioPlayerInit({required this.songPath});
}

class AudioPlayerPausePlay extends AudioPlayerEvent {}

class AudioPlayerNext10 extends AudioPlayerEvent {}

class AudioPlayerPrevious10 extends AudioPlayerEvent {}

class AudioPlayerNextSong extends AudioPlayerEvent {}

class AudioPlayerPreviousSong extends AudioPlayerEvent {}

class AudioPlayerDispose extends AudioPlayerEvent {}
