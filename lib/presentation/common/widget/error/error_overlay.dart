import 'package:flutter/material.dart';
import 'package:music_player/presentation/common/errorhandling/base/error_bundle.dart';
import 'package:music_player/presentation/common/localization/app_localizations.dart';
import 'package:music_player/presentation/common/localization/localization_manager.dart';

class ErrorOverlay {
  BuildContext _context;

  ErrorOverlay._create(this._context);

  factory ErrorOverlay.of(BuildContext context) {
    return ErrorOverlay._create(context);
  }

  void show(ErrorBundle? error,
      {VoidCallback? onRetry, bool? showSupportCode}) {
    if (error == null) {
      return;
    }

    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            title: Text(AppLocalizations.of(context)!.error_title),
            content: showSupportCode != false
                ? RichText(
                    text: TextSpan(
                    text:
                        '${error.errorMessage}\n\n${localizations.error_support_code}: ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                    children: [
                      TextSpan(
                          text:
                              '${error.appAction.value}/${error.appError.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ))
                : Text(error.errorMessage),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.action_ok),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Visibility(
                visible: onRetry != null,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRetry?.call();
                  },
                  child: Text(AppLocalizations.of(context)!.action_retry),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
