import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:native_flutter_proxy/native_flutter_proxy.dart';
import '../../main.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  late final Dio _dio;

  /// Get the configured Dio instance
  Dio get dio => _dio;

  /// Initialize the Dio client with all necessary configurations
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load certificates
    await _loadCertificates();

    // Create and configure Dio instance
    _dio = Dio(_getBaseOptions())
      ..initHttpClient([
        await _configureStagingProxy(),
      ])
      ..interceptors.addAll(_getInterceptors());
  }

  /// Load and configure SSL certificates
  Future<void> _loadCertificates() async {
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }

  /// Get base options for Dio
  BaseOptions _getBaseOptions() {
    return BaseOptions(
      baseUrl: appConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
  }

  /// Configure staging proxy settings
  Future<_InitAction> _configureStagingProxy() async {
    final proxy = await _getSystemProxy();
    return _stagingProxy(proxy);
  }

  /// Get list of interceptors
  List<Interceptor> _getInterceptors() {
    return [
      AuthInterceptor(),
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
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

  /// Create staging proxy configuration action
  _InitAction _stagingProxy(String proxy) {
    return (HttpClient client) {
      if (!appConfig.isProduction && proxy.isNotEmpty) {
        client.findProxy = (uri) => proxy;
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
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