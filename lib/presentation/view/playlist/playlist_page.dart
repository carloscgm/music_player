import 'package:flutter/material.dart';
import 'package:music_player/presentation/common/localization/app_localizations.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.artists_title),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('PlaylistPage'),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
