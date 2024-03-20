import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/di/app_modules.dart';
import 'package:music_player/model/playlist.dart';
import 'package:music_player/model/song.dart';
import 'package:music_player/presentation/common/base/resource_state.dart';
import 'package:music_player/presentation/common/widget/player/neu_box.dart';
import 'package:music_player/presentation/view/playlist/viewmodel/playlist_view_model.dart';
import 'package:music_player/service/player/player_services.dart';

class PlayerPageDrawer extends StatefulWidget {
  final PlayList playlist;
  const PlayerPageDrawer({super.key, required this.playlist});

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
  bool menuDrawerPressed = true;

  //Player services
  PlayerServices playerServices = inject.get<PlayerServices>();
  PlayListViewModel playListViewModel = inject.get<PlayListViewModel>();
  List<Song> songList = [];
  int currentIndex = 0;
  int repeatMode = 0; //0 - Nada // 1 - Repeat one  // 2 - repeat all list
  Icon repeatIcon = const Icon(Icons.repeat);
  int shuffleMode = 0; //0 - nada  // 1 - next random song
  Icon shuffleIcon = const Icon(Icons.shuffle);

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

    playListViewModel.getSongsByPlaylist(widget.playlist);

    playListViewModel.getSongsByPlaylistState.stream.listen((state) {
      if (state.status == Status.COMPLETED) {
        songList = state.data;
        playerServices.initPlayer();
        playerServices.initPlay(songList[currentIndex]);
        playerServices.audioPlayer.onDurationChanged.listen((event) {
          finalDuration = event;
          setState(() {});
        });
        playerServices.audioPlayer.onPositionChanged.listen((event) {
          currentPosition = event;
          sliderValue =
              currentPosition.inSeconds / finalDuration.inSeconds * 100;
          if (mounted) {
            setState(() {});
          }
        });
        playerServices.audioPlayer.onPlayerStateChanged.listen((event) {
          isPlaying = (event == PlayerState.playing);
          if (event == PlayerState.completed) {
            if (shuffleMode == 1) {
              int randomIndex = Random().nextInt(songList.length - 1);
              while (randomIndex == currentIndex && songList.length > 1) {
                randomIndex = Random().nextInt(songList.length);
              }
              currentIndex = randomIndex;
              playerServices.initPlay(songList[currentIndex]);
            } else {
              switch (repeatMode) {
                case 0:
                  if (currentIndex < songList.length - 1) {
                    currentIndex++;
                    playerServices.initPlay(songList[currentIndex]);
                  }
                  break;
                case 1:
                  playerServices.initPlay(songList[currentIndex]);
                  break;
                case 2:
                  if (currentIndex < songList.length - 1) {
                    currentIndex++;
                    playerServices.initPlay(songList[currentIndex]);
                  } else if (currentIndex == songList.length - 1) {
                    currentIndex = 0;
                    playerServices.initPlay(songList[currentIndex]);
                  }
                  break;
                default:
              }
            }
          }
          if (mounted) {
            setState(() {});
          }
        });
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
        ],
      ),
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
            //clipBehavior: Clip.none,
            children: [
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
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            Text(widget.playlist.name,
                                style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 15),
                            Expanded(
                              child: ListView.builder(
                                itemCount: songList.length,
                                itemBuilder: (context, index) {
                                  return customListTile(index);
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    menuDrawerPressed = true;
                                    menuPressed = false;
                                    _animationController.reverse();
                                  },
                                  child: NeuBox(
                                    padding: 20,
                                    isPressed: menuDrawerPressed,
                                    child: const Icon(Icons.menu),
                                  ),
                                ),
                                IconButton(
                                    onPressed: repeatPressed, icon: repeatIcon),
                                IconButton(
                                    onPressed: shufflePressed,
                                    icon: shuffleIcon),
                              ],
                            )
                          ],
                        )),
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
                    left: 25, right: 25, bottom: 25, top: _extraHeight + 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const NeuBox(
                            isPressed: false,
                            padding: 20,
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: (widget.playlist.songsTitles.length > 1)
                              ? Text(
                                  widget.playlist.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Container(),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            menuDrawerPressed = false;
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
                                child: NeuBox(
                                  isPressed: true,
                                  child: playerServices.currentSong != null
                                      ? Container()
                                      : const Center(
                                          child: CircularProgressIndicator()),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  playerServices.currentSong != null
                                      ? playerServices.currentSong!.title
                                      : '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  playerServices.currentSong != null
                                      ? playerServices.currentSong!.getArtist()
                                      : '',
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
                            onTap: () {
                              if (currentIndex > 0) {
                                currentIndex--;
                                playerServices.initPlay(songList[currentIndex]);
                              }
                            },
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
                            onTap: () {
                              if (currentIndex < songList.length - 1) {
                                currentIndex++;
                                playerServices.initPlay(songList[currentIndex]);
                              }
                            },
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

  String stringByDuration(Duration position) {
    if (position.inSeconds % 60 < 10) {
      return '${position.inMinutes}:0${position.inSeconds % 60}';
    } else {
      return '${position.inMinutes}:${position.inSeconds % 60}';
    }
  }

  //0 - Nada // 1 - Repeat one  // 2 - repeat all list
  repeatPressed() {
    repeatMode++;
    if (repeatMode == 3) repeatMode = 0;
    switch (repeatMode) {
      case 0:
        repeatIcon = const Icon(Icons.repeat);
        break;
      case 1:
        repeatIcon = const Icon(Icons.repeat_one);
        break;
      case 2:
        repeatIcon = const Icon(Icons.repeat_on_outlined);
        break;
    }
  }

  //0 - nada  // 1 - next random song
  shufflePressed() {
    if (shuffleMode == 0) {
      shuffleMode = 1;
      shuffleIcon = const Icon(Icons.shuffle_on_outlined);
    } else {
      shuffleMode = 0;
      shuffleIcon = const Icon(Icons.shuffle);
    }
  }

  Widget customListTile(int index) {
    return GestureDetector(
      onTap: () {
        currentIndex = index;
        playerServices.initPlay(songList[index]);
      },
      child: Container(
        margin: EdgeInsets.only(left: index == currentIndex ? 0 : 25),
        height: 50,
        child: Row(
          children: [
            index == currentIndex
                ? Image.asset('assets/images/music2.gif', height: 25, width: 25)
                : Container(),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                songList[index].title,
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
