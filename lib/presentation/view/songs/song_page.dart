import 'package:flutter/material.dart';
import 'package:music_player/presentation/common/localization/app_localizations.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage>
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
          child: Text('Songs Page'),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
