import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:music_player/core/extensions/core_string_extensions.dart';

class DioLoggingInterceptor extends Interceptor {
  DioLoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();

    buffer.writeln('<-- HTTP ${options.method} Request');
    buffer.writeln(' Uri: ${options.uri}');
    buffer.writeln(' Headers:');
    options.headers.forEach((key, v) => buffer.writeln('  - $key: $v'));
    buffer.writeln(' Extra: ${options.extra.toString()}');
    buffer.writeln(' Body: ${options.data.toString()}');
    buffer.writeln('--> END HTTP ${options.method} Request');

    _debugPrint(buffer.toString());

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();

    buffer.writeln('<-- HTTP Error');
    buffer.writeln(' Uri: ${err.requestOptions.uri}');

    if (err.response != null) {
      buffer.writeln(' Status code: ${err.response?.statusCode.toString()}');
    }

    buffer.writeln(' Error: ${err.error}');

    if (err.message != null) {
      buffer.writeln(' Message: ${err.message}');
    }

    buffer.writeln('--> END HTTP Error');

    _debugPrint(buffer.toString());

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer();

    buffer.writeln('<-- HTTP ${response.requestOptions.method} Response');

    buffer.writeln(' Uri: ${response.realUri}');
    buffer.writeln(' Status Code: ${response.statusCode}');
    buffer.writeln(' Redirect: ${response.isRedirect}');
    buffer.writeln(' Headers:');
    response.headers
        .forEach((key, v) => buffer.writeln('  - $key: ${v.join('\r\n\t')}'));
    buffer.writeln(' Body: ${response.toString().truncateTo(3000)}');

    buffer.writeln('--> END HTTP ${response.requestOptions.method} Response');

    _debugPrint(buffer.toString());

    handler.next(response);
  }

  void _debugPrint(String data) {
    log(data);
  }
}
