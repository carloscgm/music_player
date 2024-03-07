import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/presentation/view/home/home_page.dart';
import 'package:music_player/presentation/view/playlist/playlist_page.dart';
import 'package:music_player/presentation/view/settings/settings_page.dart';
import 'package:music_player/presentation/view/songs/song_page.dart';
import 'package:music_player/presentation/view/splash/splash_page.dart';

abstract class NavigationRoutes {
  // Route paths (for subroutes) - private access
  static const String _artistDetailPath = 'detail';

  // Route names
  static const String initialRoute = '/';
  static const String artistsRoute = '/artists';
  static const String artistDetailRoute = '$artistsRoute/$_artistDetailPath';

  static const String playListRoute = '/playlist';
  static const String songRoute = '/songs';
  static const String settingsRoute = '/settings';
  static const String splashRoute = '/splash';
}

// Nav keys
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _playlistNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _songsNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey<NavigatorState>();

final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: NavigationRoutes.splashRoute,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomePage(navigationShell: shell),
        branches: [
          StatefulShellBranch(navigatorKey: _playlistNavigatorKey, routes: [
            GoRoute(
              path: NavigationRoutes.playListRoute,
              parentNavigatorKey: _playlistNavigatorKey,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: PlayListPage()),
            ),
          ]),
          StatefulShellBranch(navigatorKey: _songsNavigatorKey, routes: [
            GoRoute(
                path: NavigationRoutes.songRoute,
                parentNavigatorKey: _songsNavigatorKey,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SongsPage())),
          ]),
          StatefulShellBranch(navigatorKey: _settingsNavigatorKey, routes: [
            GoRoute(
                path: NavigationRoutes.settingsRoute,
                parentNavigatorKey: _settingsNavigatorKey,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingsPage())),
          ])
        ],
      ),
      GoRoute(
          path: NavigationRoutes.splashRoute,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SplashPage())),
    ]);
