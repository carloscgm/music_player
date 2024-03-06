import 'package:flutter/material.dart';
import 'package:music_player/presentation/common/localization/app_localizations.dart';
import 'package:music_player/presentation/common/resources/app_dimens.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about_title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.mediumMargin),
            child: Text(
                AppLocalizations.of(context)!
                    .about_description('Clean Architecture', 'Dart'),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
