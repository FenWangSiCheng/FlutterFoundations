import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_foundations/core/network/interceptors/auth_interceptor.dart';

// Test handler to capture the call to next()
class TestRequestInterceptorHandler extends RequestInterceptorHandler {
  RequestOptions? capturedOptions;
  bool nextCalled = false;

  @override
  void next(RequestOptions requestOptions) {
    capturedOptions = requestOptions;
    nextCalled = true;
  }
}

void main() {
  late AuthInterceptor authInterceptor;
  late TestRequestInterceptorHandler testHandler;

  setUp(() {
    authInterceptor = AuthInterceptor();
    testHandler = TestRequestInterceptorHandler();
  });

  group('AuthInterceptor', () {
    test('should add token header when x-rcms-api-access-token not present',
        () {
      final options = RequestOptions(
        path: '/test',
        headers: {'content-type': 'application/json'},
      );

      authInterceptor.onRequest(options, testHandler);

      expect(options.headers.containsKey('token'), isTrue);
      expect(options.headers['token'], equals(''));
      expect(testHandler.nextCalled, isTrue);
      expect(testHandler.capturedOptions, equals(options));
    });

    test('should not add token header when x-rcms-api-access-token is present',
        () {
      final options = RequestOptions(
        path: '/test',
        headers: {
          'content-type': 'application/json',
          'x-rcms-api-access-token': 'existing-token',
        },
      );

      authInterceptor.onRequest(options, testHandler);

      expect(options.headers.containsKey('token'), isFalse);
      expect(
        options.headers.containsKey('x-rcms-api-access-token'),
        isTrue,
      );
      expect(testHandler.nextCalled, isTrue);
    });

    test('should call handler.next with modified options', () {
      final options = RequestOptions(path: '/test');

      authInterceptor.onRequest(options, testHandler);

      expect(testHandler.nextCalled, isTrue);
      expect(testHandler.capturedOptions, equals(options));
    });

    test('should preserve existing headers', () {
      final options = RequestOptions(
        path: '/test',
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer test-token',
          'custom-header': 'custom-value',
        },
      );

      authInterceptor.onRequest(options, testHandler);

      expect(options.headers['content-type'], equals('application/json'));
      expect(options.headers['authorization'], equals('Bearer test-token'));
      expect(options.headers['custom-header'], equals('custom-value'));
      expect(options.headers['token'], equals(''));
    });

    test('should handle empty headers map', () {
      final options = RequestOptions(
        path: '/test',
        headers: {},
      );

      authInterceptor.onRequest(options, testHandler);

      expect(options.headers.containsKey('token'), isTrue);
      expect(options.headers['token'], equals(''));
      expect(testHandler.nextCalled, isTrue);
    });

    test('should be an instance of Interceptor', () {
      expect(authInterceptor, isA<Interceptor>());
    });
  });
}