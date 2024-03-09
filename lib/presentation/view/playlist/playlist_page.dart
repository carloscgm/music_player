import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/di/app_modules.dart';
import 'package:music_player/model/playlist.dart';
import 'package:music_player/presentation/common/base/resource_state.dart';
import 'package:music_player/presentation/common/localization/app_localizations.dart';
import 'package:music_player/presentation/common/widget/error/error_overlay.dart';
import 'package:music_player/presentation/common/widget/loading/loading_overlay.dart';
import 'package:music_player/presentation/navigation/navigation_routes.dart';
import 'package:music_player/presentation/view/playlist/viewmodel/playlist_view_model.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage>
    with AutomaticKeepAliveClientMixin {
  final _playListViewModel = inject<PlayListViewModel>();
  List<PlayList> _playList = [];

  @override
  void initState() {
    super.initState();

    _playListViewModel.playlistListState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingOverlay.show(context);
          break;
        case Status.COMPLETED:
          LoadingOverlay.hide();
          setState(() {
            _playList = state.data;
          });
          break;
        case Status.ERROR:
          LoadingOverlay.hide();
          ErrorOverlay.of(context).show(state.error, onRetry: () {
            _playListViewModel.fetchPlayList();
          });
          break;
        default:
          LoadingOverlay.hide();
          break;
      }
    });
    _playListViewModel.fetchPlayList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.playlist_title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _playList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_playList[index].name),
            subtitle: Text('${_playList[index].songsTitles.length} canciones'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(NavigationRoutes.addSongPlayListRoute);
          print('lo ejecuto ahora');
          _playListViewModel.fetchPlayList();
        },
        label: Text(AppLocalizations.of(context)!.playlist_add),
        icon: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
