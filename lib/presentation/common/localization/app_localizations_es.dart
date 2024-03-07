import 'app_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_title => 'Flutter MVVM';

  @override
  String get home_title => 'Inicio';

  @override
  String get artists_title => 'Artistas';

  @override
  String get about_title => 'Acerca de';

  @override
  String about_description(Object cleanArch, Object lang) {
    return 'Ejemplo de MVVM en Flutter.\n\nDesarrollado en lenguaje $lang siguiendo los principios de $cleanArch.';
  }

  @override
  String get sign_in => 'Iniciar sesión';

  @override
  String get sign_in_welcome_title => '¡Bienvenid@!';

  @override
  String get sign_in_welcome_subtitle => 'Introduce tus datos de usuario para continuar';

  @override
  String get sign_in_username => 'Usuario';

  @override
  String get sign_in_username_hint => 'Introduce tu usuario';

  @override
  String get sign_in_password => 'Contraseña';

  @override
  String get sign_in_password_hint => 'Introduce tu contraseña';

  @override
  String get sign_out => 'Cerrar sesión';

  @override
  String get error_title => 'Error';

  @override
  String get error_default => 'Ha ocurrido un error.';

  @override
  String get error_timeout => 'Estamos experimentando algunos problemas temporales. Por favor, inténtalo de nuevo en unos minutos.';

  @override
  String get error_unauthorized => 'Tu sesión ha expirado y no hemos podido renovarla. Por favor, inicia sesión de nuevo.';

  @override
  String get error_no_internet => 'No hay conexión a Internet. Comprueba tu conexión Wi-Fi o de datos móviles, por favor.';

  @override
  String get error_server => 'Estamos experimentando algunos problemas en este momento. Por favor, vuelve de nuevo mas tarde.';

  @override
  String get error_not_found => 'No encontramos lo que necesitas. Por favor, inténtalo de nuevo más tarde.';

  @override
  String get error_empty_field => 'Este campo no puede estar vacío';

  @override
  String get error_support_code => 'Código de soporte';

  @override
  String get action_ok => 'Aceptar';

  @override
  String get action_cancel => 'Cancelar';

  @override
  String get action_retry => 'Reintentar';

  @override
  String get playlist_title => 'Listas';

  @override
  String get playlist_add => 'Nueva lista';

  @override
  String get songs_title => 'Canciones';

  @override
  String get settings_title => 'Ajustes';

  @override
  String get songs_empty => 'No hay canciones todavía';
}
