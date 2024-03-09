import 'package:flutter/material.dart';
import 'package:music_player/presentation/common/resources/app_colors.dart';

class AppStyles {
  // App Theme
  static ThemeData appTheme = ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: Colors.blue,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundGrey,
    appBarTheme: const AppBarTheme(color: AppColors.backgroundGrey),
  ).copyWith(
    sliderTheme: const SliderThemeData(
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0)),
    textTheme: TextTheme(
      titleSmall: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
      labelMedium: const TextStyle(color: Colors.black, fontSize: 14),
      labelSmall: TextStyle(color: Colors.grey[800], fontSize: 14),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData appDarkTheme = ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.backgroundBlack,
          appBarTheme: const AppBarTheme(color: AppColors.backgroundBlack))
      .copyWith(
    textTheme: TextTheme(
      titleSmall: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      labelMedium: const TextStyle(color: Colors.white, fontSize: 14),
      labelSmall: TextStyle(color: Colors.grey[100], fontSize: 14),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  // Text Styles
  static const TextStyle smallTextStyle = TextStyle(fontSize: 14);
  static const TextStyle bigTextStyle = TextStyle(fontSize: 18);
  static const TextStyle extraBigTextStyle = TextStyle(fontSize: 22);
}
