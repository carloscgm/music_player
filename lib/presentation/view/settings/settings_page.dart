import 'package:flutter/material.dart';
import 'package:music_player/presentation/common/localization/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings_title),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'Settings Page',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
