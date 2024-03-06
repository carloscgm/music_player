# Flutter Clean Architecture Template

A simple application that serves as a template for the development of Flutter applications with Clean Architecture and the MVVM pattern. Includes login, authenticated network requests, error handling and token refresh.

## Libraries and tools used

- [Dart](https://dart.dev/get-dart)
- [Flutter](https://docs.flutter.dev/get-started/install)
- [dio](https://pub.dev/packages/dio)
- [go_router](https://pub.dev/packages/go_router)
- [intl](https://pub.dev/packages/intl)
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)
- [cached_network_image](https://pub.dev/packages/cached_network_image)
- [animations](https://pub.dev/packages/animations)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
- [cupertino_icons](https://pub.dev/packages/cupertino_icons)
- [flutter_lints](https://pub.dev/packages/flutter_lints)
- [flutter_localizations](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

## Requirements
- Flutter SDK 3.7+
- Dart SDK
- Android Studio or Visual Studio Code
- (Optional) Latest Android and iOS SDK Tools and build tools.

## Update localizations

Whenever changes are made to the *.arb translation files, it is necessary to execute this command to update the values in the AppLocalizations class:

```
flutter gen-l10n
```

For more information about how the Flutter localizations work, please refer to this [web page](https://docs.flutter.dev/accessibility-and-localization/internationalization).