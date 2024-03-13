import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/model/song.dart';
import 'package:music_player/presentation/common/widget/player/neu_box.dart';
import 'package:music_player/presentation/view/player/bloc/audio_player_bloc.dart';

class PlayerPageDrawer extends StatefulWidget {
  final Song song;
  const PlayerPageDrawer({super.key, required this.song});

  @override
  State<PlayerPageDrawer> createState() => _PlayerPageDrawerState();
}

class _PlayerPageDrawerState extends State<PlayerPageDrawer>
    with SingleTickerProviderStateMixin {
  //controllers 3D effect
  double _maxSlide = 0.75;
  double _extraHeight = 0.1;
  late AnimationController _animationController;
  Size _screen = const Size(0, 0);
  late Size _responsive;
  late CurvedAnimation _animator;

  //controller audioplayer

  bool playPressed = false;
  bool skipPreviousPressed = false;
  bool skipNextPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animator = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
      reverseCurve: Curves.easeInQuad,
    );
  }

  @override
  void didChangeDependencies() {
    _screen = MediaQuery.of(context).size;
    _maxSlide *= _screen.width;
    _extraHeight *= _screen.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayerBloc apb = context.read<AudioPlayerBloc>();
    apb.add(AudioPlayerInit(songPath: widget.song.path));

    _responsive = MediaQuery.of(context).size;
    return Material(
      child: Stack(
        children: [
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          _playerScreen(),
          _playListDrawer(),
          _myHeader(),
        ],
      ),
    );
  }

  Widget _myAppBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NeuBox(
            padding: 5,
            child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back)),
          ),
          NeuBox(
            padding: 5,
            child: IconButton(
                onPressed: () {
                  if (_animationController.value < 0.5) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
                icon: const Icon(Icons.menu)),
          )
        ],
      ),
    );
  }

  Widget _myHeader() {
    return SafeArea(
      child: AnimatedBuilder(
          animation: _animator,
          builder: (_, __) {
            return Transform.translate(
              offset: Offset((-_screen.width + 80) * _animator.value, 0),
              child: _myAppBar(),
            );
          }),
    );
  }

  Widget _playListDrawer() {
    return Positioned.fill(
      top: -_extraHeight,
      bottom: -_extraHeight,
      right: 0,
      left: _screen.width - _maxSlide,
      child: AnimatedBuilder(
        animation: _animator,
        builder: (context, widget) {
          return Transform.translate(
            offset: Offset(-_maxSlide * (_animator.value - 1), 0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-pi * (1 - _animator.value) / 2),
              alignment: Alignment.centerLeft,
              child: widget,
            ),
          );
        },
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: Container(
                  width: 5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black12],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: _extraHeight,
                bottom: _extraHeight,
                child: SafeArea(
                  child: SizedBox(
                    width: _maxSlide,
                    child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                'Cancion $index',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            );
                          },
                        )),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _animator,
                builder: (_, __) => Container(
                  width: _maxSlide,
                  color: Colors.black.withAlpha(
                    (150 * (1 - _animator.value)).floor(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playerScreen() {
    return Positioned.fill(
      top: -_extraHeight,
      bottom: -_extraHeight,
      child: AnimatedBuilder(
        animation: _animator,
        builder: (context, widget) => Transform.translate(
          offset: Offset(-_maxSlide * _animator.value, 0),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((-pi / 2 + 0.1) * -_animator.value),
            alignment: Alignment.centerRight,
            child: widget,
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, bottom: 25, top: 150),
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    //Album artwork
                    NeuBox(
                      child: Column(
                        children: [
                          SizedBox(
                            height: _responsive.height * 0.35,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: BlocBuilder<AudioPlayerBloc,
                                    AudioPlayerState>(
                                  builder: (context, state) {
                                    return state.currentSong.getImage();
                                  },
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child:
                                BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.currentSong.getTitle(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      state.currentSong.getArtist(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    )
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    //song duration progress
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getCurrentPosition(
                                        state.audioplayer.position),
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<AudioPlayerBloc>()
                                          .add(AudioPlayerPrevious10());
                                    },
                                    icon: const Icon(Icons.replay_10),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<AudioPlayerBloc>()
                                          .add(AudioPlayerNext10());
                                    },
                                    icon: const Icon(Icons.forward_10),
                                  ),
                                  Text(
                                    state.audioplayer.duration != null
                                        ? getDurationOfSong(
                                            state.audioplayer.duration!)
                                        : '',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                          builder: (context, state) {
                            return NeuBox(
                              padding: 0,
                              child: Slider(
                                min: 0,
                                max: 100,
                                value: state.audioplayer.duration != null
                                    ? state.audioplayer.position.inSeconds /
                                        state.audioplayer.duration!.inSeconds
                                    : 0.0,
                                activeColor: Colors.green,
                                onChanged: (double value) {},
                              ),
                            );
                          },
                        )
                      ],
                    ),

                    //playback controls
                    const SizedBox(height: 25),

                    //playback and controls
                    Row(
                      children: [
                        //skip previous
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTapDown: (details) {
                              setState(() {
                                skipNextPressed = true;
                              });
                            },
                            onTapUp: (details) {
                              setState(() {
                                skipNextPressed = false;
                              });
                            },
                            onTap: () => context
                                .read<AudioPlayerBloc>()
                                .add(AudioPlayerPreviousSong()),
                            child: NeuBox(
                              isPressed: skipNextPressed,
                              child: const Icon(Icons.skip_previous),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),
                        //play/pause
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () => context
                                .read<AudioPlayerBloc>()
                                .add(AudioPlayerPausePlay()),
                            onTapDown: (details) {
                              setState(() {
                                playPressed = true;
                              });
                            },
                            onTapUp: (details) {
                              setState(() {
                                playPressed = false;
                              });
                            },
                            child:
                                BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                              builder: (context, state) {
                                return NeuBox(
                                  isPressed: playPressed,
                                  child: Icon(state.audioplayer.playing
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),
                        // skip next
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTapDown: (details) {
                              setState(() {
                                skipPreviousPressed = true;
                              });
                            },
                            onTapUp: (details) {
                              setState(() {
                                skipPreviousPressed = false;
                              });
                            },
                            onTap: () => context
                                .read<AudioPlayerBloc>()
                                .add(AudioPlayerNextSong()),
                            child: NeuBox(
                              isPressed: skipPreviousPressed,
                              child: const Icon(Icons.skip_next),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getCurrentPosition(Duration position) {
    String result = '${position.inMinutes}:';
    if (position.inSeconds < 10) {
      return '${result}0${position.inSeconds}';
    } else {
      return '$result${position.inSeconds}';
    }
  }

  String getDurationOfSong(Duration position) {
    if (position.inSeconds % 60 < 10) {
      return '${position.inMinutes}:0${position.inSeconds % 60}';
    } else {
      return '${position.inMinutes}:${position.inSeconds % 60}';
    }
  }
}
