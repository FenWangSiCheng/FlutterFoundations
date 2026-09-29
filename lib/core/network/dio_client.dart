import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:native_flutter_proxy/native_flutter_proxy.dart';

import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  final AppConfig _appConfig;
  final Future<void> Function(DioAdapter)? _configureMock;
  late final Dio _dio;

  DioClient(this._appConfig, {Future<void> Function(DioAdapter)? configureMock})
    : _configureMock = configureMock;

  Dio get dio => _dio;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    _dio = Dio(_getBaseOptions());

    if (_appConfig.mockApiDataSource) {
      await _setupMockAdapter();
    } else if (_appConfig.isNeedProxy && !_appConfig.isProduction) {
      final proxy = await _getSystemProxy();
      final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;
      adapter.createHttpClient = () {
        final client = HttpClient();
        if (proxy.isNotEmpty) {
          client.findProxy = (uri) => proxy;
        }
        return client;
      };
    }

    _dio.interceptors.addAll(_getInterceptors());
  }

  BaseOptions _getBaseOptions() => BaseOptions(
    baseUrl: _appConfig.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  List<Interceptor> _getInterceptors() => [
    AuthInterceptor(),
    if (kDebugMode)
      LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
      ),
  ];

  Future<String> _getSystemProxy() async {
    try {
      final settings = await NativeProxyReader.proxySetting;
      if (settings.enabled && settings.host != null && settings.port != null) {
        return 'PROXY ${settings.host}:${settings.port}';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get system proxy: $e');
      }
    }
    return '';
  }

  Future<void> _setupMockAdapter() async {
    final configureMock = _configureMock;
    if (configureMock == null) {
      throw StateError('Mock API is enabled without a mock configuration.');
    }
    final dioAdapter = DioAdapter(dio: _dio);
    _dio.httpClientAdapter = dioAdapter;
    await configureMock(dioAdapter);
  }
}
