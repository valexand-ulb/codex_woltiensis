import 'dart:core';

class Endpoint {
  static const apiScheme = 'https';
  static const apiHost = 'valexand-ulb.github.io';
  static const apiPath = 'codex_woltiensis_api';

  static Uri uri(String path, {Map<String, dynamic>? queryParameters}) {
    return Uri(
      scheme: apiScheme,
      host: apiHost,
      path: '$apiPath/$path',
      queryParameters: queryParameters,
    );
  }
}
