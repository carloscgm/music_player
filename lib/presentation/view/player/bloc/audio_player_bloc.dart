import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/domain/playlist_repository.dart';
import 'package:music_player/domain/songs_repository.dart';
import 'package:music_player/model/playlist.dart';
import 'package:music_player/model/song.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  PlayListRepository playListRepository;
  SongsRepository songsRepository;

  AudioPlayerBloc(this.playListRepository, this.songsRepository)
      : super(AudioPlayerState(
            audioplayer: AudioPlayer(), currentSong: Song.fromData('', ''))) {
    on<AudioPlayerInit>((event, emit) async {
      Song s = await songsRepository.getSongByPath(event.songPath);
      state.audioplayer.setFilePath(event.songPath);
      emit(state.copyWith(currentSong: s));
      //add(AudioPlayerPausePlay());
    });

    on<AudioPlayerPausePlay>((event, emit) {
      state.audioplayer.playing
          ? state.audioplayer.pause()
          : state.audioplayer.play();
      emit(AudioPlayerState(
          audioplayer: state.audioplayer, currentSong: state.currentSong));
    });

    on<AudioPlayerNext10>((event, emit) {
      state.audioplayer
          .seek(state.audioplayer.position + const Duration(seconds: 10));
    });

    on<AudioPlayerPrevious10>((event, emit) {
      state.audioplayer
          .seek(state.audioplayer.position - const Duration(seconds: 10));
    });

    on<AudioPlayerNextSong>((event, emit) {
      state.audioplayer.seekToNext();
    });

    on<AudioPlayerPreviousSong>((event, emit) {
      state.audioplayer.seekToPrevious();
    });

    on<AudioPlayerDispose>((event, emit) {
      state.audioplayer.stop();
      state.audioplayer.dispose();
    });
  }
}
