import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:native_flutter_proxy/native_flutter_proxy.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  final AppConfig _appConfig;
  final Future<void> Function(DioAdapter)? _configureMock;
  late final Dio _dio;

  DioClient(this._appConfig, {Future<void> Function(DioAdapter)? configureMock})
    : _configureMock = configureMock;

  /// Get the configured Dio instance
  Dio get dio => _dio;

  /// Initialize the Dio client with all necessary configurations
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Create and configure Dio instance
    _dio = Dio(_getBaseOptions());

    // Configure adapter based on mock setting
    if (_appConfig.mockApiDataSource) {
      await _setupMockAdapter();
    } else {
      if (_appConfig.isNeedProxy && !_appConfig.isProduction) {
        _dio.initHttpClient([await _configureProxy()]);
      }
    }

    // Add interceptors
    _dio.interceptors.addAll(_getInterceptors());
  }

  /// Get base options for Dio
  BaseOptions _getBaseOptions() {
    return BaseOptions(
      baseUrl: _appConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
  }

  /// Configure staging proxy settings
  Future<_InitAction> _configureProxy() async {
    final proxy = await _getSystemProxy();
    return _proxyAction(proxy);
  }

  /// Get list of interceptors
  List<Interceptor> _getInterceptors() {
    return [
      AuthInterceptor(),
      if (kDebugMode)
        LogInterceptor(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
        ),
    ];
  }

  /// Get system proxy settings
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

  /// Setup mock adapter for development environment
  Future<void> _setupMockAdapter() async {
    if (_configureMock == null) {
      throw StateError('Mock API is enabled without a mock configuration.');
    }
    final dioAdapter = DioAdapter(dio: _dio);
    _dio.httpClientAdapter = dioAdapter;
    await _configureMock(dioAdapter);
  }

  /// Create staging proxy configuration action
  _InitAction _proxyAction(String proxy) {
    return (HttpClient client) {
      if (proxy.isNotEmpty) {
        client.findProxy = (uri) => proxy;
      }
    };
  }
}

/// Extension to add HTTP client initialization capability to Dio
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

/// Type definition for HTTP client initialization actions
typedef _InitAction = void Function(HttpClient client);
