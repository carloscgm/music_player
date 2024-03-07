import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/core/di/app_modules.dart';
import 'package:music_player/presentation/common/base/resource_state.dart';
import 'package:music_player/presentation/common/resources/app_colors.dart';
import 'package:music_player/presentation/navigation/navigation_routes.dart';
import 'package:music_player/presentation/view/songs/viewmodel/songs_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with AutomaticKeepAliveClientMixin {
  final _songViewModel = inject<SongsViewModel>();

  @override
  void initState() {
    super.initState();

    Permission.audio
        .onGrantedCallback(() => context.go(NavigationRoutes.playListRoute));

    _songViewModel.permissionState.stream.listen((state) async {
      if (state.status == Status.COMPLETED) {
        switch (state.data) {
          case PermissionStatus.granted:
            context.go(NavigationRoutes.playListRoute);
            break;
          case PermissionStatus.denied:
            showDialog(
              context: context,
              builder: (context) =>
                  MyAlertDialog(songViewModel: _songViewModel),
            );
            break;
          case PermissionStatus.permanentlyDenied:
            showDialog(
              context: context,
              builder: (context) =>
                  MyAlertDialog(songViewModel: _songViewModel),
            );
        }
      }
    });

    _songViewModel.permissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const Scaffold(
      backgroundColor: AppColors.backgroundGrey,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _songViewModel.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    super.key,
    required SongsViewModel songViewModel,
  }) : _songViewModel = songViewModel;

  final SongsViewModel _songViewModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      actions: [
        const TextButton(
            onPressed: openAppSettings, child: Text('Ir a ajustes')),
        TextButton(
            onPressed: () async {
              context.pop();
              await Permission.audio.request();
              _songViewModel.permissionStatus();
            },
            child: const Text('Reintentar')),
      ],
      title: const Text(
        'Permiso de audio',
        style: TextStyle(color: Colors.black),
      ),
      contentPadding: const EdgeInsets.all(15),
      content: const Text(
          'La app no puede continuar sin el permiso para leer los archivos de música.',
          style: TextStyle(color: Colors.black)),
    );
  }
}
