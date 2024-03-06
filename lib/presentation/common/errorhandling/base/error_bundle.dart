import 'package:music_player/presentation/common/errorhandling/app_action.dart';
import 'package:music_player/presentation/common/errorhandling/app_error.dart';

class ErrorBundle {
  final Exception exception;
  final AppAction appAction;
  final AppError appError;
  final String errorMessage;

  ErrorBundle(this.exception, this.appAction, this.appError, this.errorMessage);

  String get message {
    return exception.toString();
  }
}
