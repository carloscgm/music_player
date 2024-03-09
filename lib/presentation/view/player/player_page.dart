import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/model/song.dart';
import 'package:music_player/presentation/common/widget/player/neu_box.dart';

class PlayerPage extends StatefulWidget {
  final Song song;
  const PlayerPage({super.key, required this.song});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: Column(
            children: [
              //App bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
                ],
              ),

              const SizedBox(height: 25),

              //Album artwork
              NeuBox(
                child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.song.getImage()),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.song.getTitle(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                //TODO: meter el album
                                Text(
                                  'Album',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite),
                            color: Colors.red,
                          )
                        ],
                      ),
                    )
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
                          '00:00',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          '00:00',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    min: 0,
                    max: 100,
                    value: 50,
                    activeColor: Colors.green,
                    onChanged: (value) {},
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
                      onTap: () {},
                      child: const NeuBox(
                        child: Icon(Icons.skip_previous),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // back 10 seconds
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {},
                      child: const NeuBox(
                        child: Icon(Icons.replay_10),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  //play/pause
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {},
                      child: const NeuBox(
                        child: Icon(Icons.play_arrow),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  //forward 10 seconds
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {},
                      child: const NeuBox(
                        child: Icon(Icons.forward_10),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  // skip next
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {},
                      child: const NeuBox(
                        child: Icon(Icons.skip_next),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
