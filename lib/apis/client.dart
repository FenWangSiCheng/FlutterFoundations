import 'dart:io';
import '../app_config.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:system_proxy/system_proxy.dart';

Future<Dio> provideDio() async {
  WidgetsFlutterBinding.ensureInitialized();

  return Dio(_options)
    ..initHttpClient([
      _stagingProxy(await _getSystemProxy()),
    ])
    ..interceptors.addAll([
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
    ]);
}

BaseOptions _options = BaseOptions(
  baseUrl: AppConfig.baseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
);

extension _DioInitExt on Dio {
  void initHttpClient(List<_InitAction> actions) {
    (httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      for (var action in actions) {
        action.call(client);
      }
      return client;
    };
  }
}

typedef _InitAction = void Function(HttpClient client);

Future<String> _getSystemProxy() async {
  final proxy = await SystemProxy.getProxySettings();
  final host = proxy?['host'];
  final port = proxy?['port'];
  if (host != null && port != null) {
    return "PROXY $host:$port";
  } else {
    return "";
  }
}

_InitAction _stagingProxy(String proxy) {
  return (HttpClient client) {
    if (AppConfig.isNeedProxy && proxy.isNotEmpty) {
      client.findProxy = (uri) => proxy;
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }
  };
}
