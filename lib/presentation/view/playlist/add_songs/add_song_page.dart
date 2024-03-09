import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/di/app_modules.dart';
import 'package:music_player/model/playlist.dart';
import 'package:music_player/model/song.dart';
import 'package:music_player/presentation/common/base/resource_state.dart';
import 'package:music_player/presentation/common/localization/app_localizations.dart';
import 'package:music_player/presentation/common/widget/error/error_overlay.dart';
import 'package:music_player/presentation/common/widget/loading/loading_overlay.dart';
import 'package:music_player/presentation/view/playlist/viewmodel/playlist_view_model.dart';
import 'package:music_player/presentation/view/songs/viewmodel/songs_view_model.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({super.key});

  @override
  State<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage>
    with AutomaticKeepAliveClientMixin {
  final _songViewModel = inject<SongsViewModel>();
  final _playListViewModel = inject<PlayListViewModel>();
  List<Song> _songList = List.empty();
  List<Song> result = List.empty(growable: true);
  List<bool> valueList = List.empty();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _songViewModel.songsListState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingOverlay.show(context);
          break;
        case Status.COMPLETED:
          LoadingOverlay.hide();
          setState(() {
            _songList = state.data;
            valueList = List.generate(_songList.length, (index) => false);
          });
          break;
        case Status.ERROR:
          LoadingOverlay.hide();
          ErrorOverlay.of(context).show(state.error, onRetry: () {
            _songViewModel.fetchSongs();
          });
          break;
        default:
          LoadingOverlay.hide();
          break;
      }
    });

    _songViewModel.fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.songs_title),
        centerTitle: true,
      ),
      body: _songList.isEmpty
          ? const EmptyListWidget()
          : Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: _songList.length,
                itemBuilder: (context, index) {
                  return Container(
                      padding: const EdgeInsets.all(10),
                      child: CheckboxListTile(
                        value: valueList[index],
                        title: Text(
                          _songList[index].title,
                          style: const TextStyle(fontSize: 14),
                        ),
                        onChanged: (bool? value) {
                          valueList[index] = value ?? false;
                          setState(() {});
                        },
                      ));
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          result.clear();
          for (int i = 0; i < valueList.length; i++) {
            if (valueList[i]) result.add(_songList[i]);
          }
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.playlist_name),
                        controller: textController,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                            onPressed: () {
                              _playListViewModel.addPlayList(PlayList(
                                  name: textController.text,
                                  songsTitles:
                                      result.map((e) => e.title).toList()));
                              context.pop();
                              context.pop();
                            },
                            child: Text(
                                AppLocalizations.of(context)!.playlist_add)),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.done),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _songViewModel.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.songs_empty,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
