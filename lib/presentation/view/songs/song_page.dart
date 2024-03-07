import 'package:flutter/material.dart';
import 'package:music_player/core/di/app_modules.dart';
import 'package:music_player/model/song.dart';
import 'package:music_player/presentation/common/base/resource_state.dart';
import 'package:music_player/presentation/common/localization/app_localizations.dart';
import 'package:music_player/presentation/common/widget/error/error_overlay.dart';
import 'package:music_player/presentation/common/widget/loading/loading_overlay.dart';
import 'package:music_player/presentation/view/songs/viewmodel/songs_view_model.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage>
    with AutomaticKeepAliveClientMixin {
  final _songViewModel = inject<SongsViewModel>();
  List<Song> _songList = List.empty();
  bool isPermissionGranted = false;

  @override
  void initState() {
    super.initState();

    _songViewModel.songsListState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          //LoadingOverlay.show(context);
          break;
        case Status.COMPLETED:
          LoadingOverlay.hide();
          setState(() {
            _songList = state.data;
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

    //_songViewModel.permissionGranted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.songs_title),
          centerTitle: true,
        ),
        body: RefreshIndicator.adaptive(
          child: _songList.isEmpty
              ? const EmptyListWidget()
              : ListSongs(list: _songList),
          onRefresh: () => _songViewModel.fetchSongs(),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _songViewModel.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class ListSongs extends StatelessWidget {
  final List<Song> list;
  const ListSongs({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(list[index].title),
          );
        },
      ),
    );
  }
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
