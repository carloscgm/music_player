import 'package:flutter/material.dart';
import 'package:music_player/presentation/common/localization/app_localizations.dart';
import 'package:music_player/presentation/common/localization/localization_manager.dart';
import 'package:music_player/presentation/navigation/navigation_routes.dart';

import 'core/di/app_modules.dart';
import 'presentation/common/resources/app_styles.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppModules().setup(); // Setup dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter MVVM',
      theme: AppStyles.appTheme,
      darkTheme: AppStyles.appDarkTheme,
      themeMode: ThemeMode.system, // Enable automatic dark theme support
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) {
        LocalizationManager.init(context: context);
        return localizations.app_title;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
