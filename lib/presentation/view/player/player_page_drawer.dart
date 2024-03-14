import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/di/app_modules.dart';
import 'package:music_player/model/song.dart';
import 'package:music_player/presentation/common/widget/player/neu_box.dart';
import 'package:music_player/service/player/player_services.dart';

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

  //neuformism effect
  bool playPressed = false;
  bool skipPreviousPressed = false;
  bool skipNextPressed = false;
  bool menuPressed = false;

  //Player services
  PlayerServices playerServices = inject.get<PlayerServices>();

  //dataStreams
  Duration currentPosition = const Duration();
  Duration finalDuration = const Duration();
  double sliderValue = 0.0;
  bool isPlaying = false;

  @override
  void dispose() {
    super.dispose();
    playerServices.dispose();
  }

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

    playerServices.initPlayer();
    playerServices.initPlay(widget.song);
    playerServices.audioPlayer.onDurationChanged.listen((event) {
      finalDuration = event;
      setState(() {});
    });
    playerServices.audioPlayer.onPositionChanged.listen((event) {
      currentPosition = event;
      sliderValue = currentPosition.inSeconds / finalDuration.inSeconds * 100;
      if (mounted) {
        setState(() {});
      }
    });
    playerServices.audioPlayer.onPlayerStateChanged.listen((event) {
      isPlaying = (event == PlayerState.playing);
      if (mounted) {
        setState(() {});
      }
    });
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
    _responsive = MediaQuery.of(context).size;
    return Material(
      child: Stack(
        children: [
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          _playerScreen(),
          _playListDrawer(),
          //_myHeader(),
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
            isPressed: menuPressed,
            padding: 5,
            child: IconButton(
                onPressed: () {
                  if (_animationController.value < 0.5) {
                    menuPressed = true;
                    _animationController.forward();
                  } else {
                    menuPressed = false;
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
                padding: EdgeInsets.only(
                    left: 25, right: 25, bottom: 25, top: _extraHeight),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const NeuBox(
                            isPressed: false,
                            padding: 20,
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            menuPressed = true;
                            _animationController.forward();
                          },
                          child: NeuBox(
                            isPressed: menuPressed,
                            padding: 20,
                            child: const Icon(Icons.menu),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    //Album artwork
                    NeuBox(
                      child: Column(
                        children: [
                          SizedBox(
                            height: _responsive.height * 0.35,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: playerServices.currentSong.getImage()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playerServices.currentSong.getTitle(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  playerServices.currentSong.getArtist(),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    //song duration progress
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                stringByDuration(currentPosition),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              IconButton(
                                onPressed: () {
                                  playerServices.seekPrevious10();
                                },
                                icon: const Icon(Icons.replay_10),
                              ),
                              IconButton(
                                onPressed: () {
                                  playerServices.seekNext10();
                                },
                                icon: const Icon(Icons.forward_10),
                              ),
                              Text(
                                stringByDuration(finalDuration),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        NeuBox(
                          padding: 0,
                          child: GestureDetector(
                            onTapDown: (details) {
                              sliderValue = (details.localPosition.dx - 20) /
                                  (MediaQuery.of(context).size.width - 90);
                              playerServices.seekPercent(sliderValue);
                            },
                            child: Slider(
                              min: 0,
                              max: 100,
                              value: sliderValue,
                              activeColor: Colors.green,
                              onChanged: (double value) {},
                            ),
                          ),
                        ),
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
                                skipPreviousPressed = true;
                              });
                            },
                            onTapUp: (details) {
                              setState(() {
                                skipPreviousPressed = false;
                              });
                            },
                            onTap: () => playerServices.previousSong(),
                            child: NeuBox(
                              padding: 20,
                              isPressed: skipPreviousPressed,
                              child: const Icon(Icons.skip_previous),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),
                        //play/pause
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () => playerServices.pausePlay(),
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
                            child: NeuBox(
                              padding: 20,
                              isPressed: playPressed,
                              child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow),
                            ),
                          ),
                        ),

                        const SizedBox(width: 25),
                        // skip next
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
                            onTap: () => playerServices.nextSong(),
                            child: NeuBox(
                              padding: 20,
                              isPressed: skipNextPressed,
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

  // String getCurrentPosition(Duration position) {
  //   String result = '${position.inMinutes}:';
  //   if (position.inSeconds < 10) {
  //     return '${result}0${position.inSeconds}';
  //   } else {
  //     return '$result${position.inSeconds}';
  //   }
  // }

  // String getDurationOfSong(Duration position) {
  //   if (position.inSeconds % 60 < 10) {
  //     return '${position.inMinutes}:0${position.inSeconds % 60}';
  //   } else {
  //     return '${position.inMinutes}:${position.inSeconds % 60}';
  //   }
  // }

  String stringByDuration(Duration position) {
    if (position.inSeconds % 60 < 10) {
      return '${position.inMinutes}:0${position.inSeconds % 60}';
    } else {
      return '${position.inMinutes}:${position.inSeconds % 60}';
    }
  }
}
