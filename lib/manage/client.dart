import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:native_flutter_proxy/native_flutter_proxy.dart';
import '../main.dart';
import 'api/interceptor/auth_interceptor.dart';

Future<Dio> provideDio() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  return Dio(_options)
    ..initHttpClient([
      _stagingProxy(await _getSystemProxy()),
    ])
    ..interceptors.addAll([
      AuthInterceptor(),
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
    ]);
}

BaseOptions _options = BaseOptions(
  baseUrl: appConfig.baseUrl,
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
  try {
    final ProxySetting settings = await NativeProxyReader.proxySetting;
    if (settings.enabled && settings.host != null && settings.port != null) {
      return "PROXY ${settings.host}:${settings.port}";
    }
  } catch (e) {
    if (kDebugMode) {
      print('Failed to get system proxy: $e');
    }
  }
  return "";
}

_InitAction _stagingProxy(String proxy) {
  return (HttpClient client) {
    if (!appConfig.isProduction && proxy.isNotEmpty) {
      client.findProxy = (uri) => proxy;
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }
  };
}
