import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({String? Function()? tokenProvider})
    : _tokenProvider = tokenProvider ?? _noToken;

  final String? Function() _tokenProvider;

  static String? _noToken() => null;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.headers.containsKey('x-rcms-api-access-token')) {
      final token = _tokenProvider();
      if (token != null && token.isNotEmpty) {
        options.headers['x-rcms-api-access-token'] = token;
      }
    }
    handler.next(options);
  }
}
