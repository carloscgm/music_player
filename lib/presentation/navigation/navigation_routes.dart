import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/model/playlist.dart';
import 'package:music_player/presentation/view/home/home_page.dart';
import 'package:music_player/presentation/view/player/player_page_drawer.dart';
import 'package:music_player/presentation/view/playlist/add_songs/add_song_page.dart';
import 'package:music_player/presentation/view/playlist/playlist_page.dart';
import 'package:music_player/presentation/view/settings/settings_page.dart';
import 'package:music_player/presentation/view/songs/song_page.dart';
import 'package:music_player/presentation/view/splash/splash_page.dart';

abstract class NavigationRoutes {
  // Route paths (for subroutes) - private access
  static const String _artistDetailPath = 'detail';
  static const String _addSongPath = 'add_song';
  //static const String _playerpath = 'player';

  // Route names
  static const String initialRoute = '/';
  static const String artistsRoute = '/artists';
  static const String artistDetailRoute = '$artistsRoute/$_artistDetailPath';

  static const String playListRoute = '/playlist';
  static const String addSongPlayListRoute = '$playListRoute/$_addSongPath';
  static const String playerRoute = '/player';
  //static const String playerPLRoute = '$playListRoute/$_playerpath';
  //static const String playerSongRoute = '$songRoute/$_playerpath';
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
                routes: [
                  GoRoute(
                      path: NavigationRoutes._addSongPath,
                      parentNavigatorKey: _playlistNavigatorKey,
                      pageBuilder: (context, state) =>
                          const NoTransitionPage(child: AddSongPage())),
                  // GoRoute(
                  //     path: NavigationRoutes._playerpath,
                  //     parentNavigatorKey: _playlistNavigatorKey,
                  //     pageBuilder: (context, state) =>
                  //         const NoTransitionPage(child: PlayerPage())),
                ]),
          ]),
          StatefulShellBranch(navigatorKey: _songsNavigatorKey, routes: [
            GoRoute(
              path: NavigationRoutes.songRoute,
              parentNavigatorKey: _songsNavigatorKey,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SongsPage()),
              routes: const [],
            ),
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
          path: NavigationRoutes.playerRoute,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) {
            final PlayList extra = state.extra as PlayList;
            return NoTransitionPage(child: PlayerPageDrawer(playlist: extra));
          }),
      GoRoute(
          path: NavigationRoutes.splashRoute,
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SplashPage())),
    ]);
