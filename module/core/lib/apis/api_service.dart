import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;

  ApiService({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 3),
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            );

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    return _request(() => dio.get(url, queryParameters: queryParameters));
  }

  Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    return _request(() => dio.post(url, data: data));
  }

  Future<Response> _request(Future<Response> Function() request) async {
    try {
      final response = await request();
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException("Connection timeout");
      case DioExceptionType.receiveTimeout:
        return ApiException("Receive timeout");
      case DioExceptionType.sendTimeout:
        return ApiException("Send timeout");
      case DioExceptionType.badResponse:
        return ApiException(
            "Received invalid status code: ${error.response?.statusCode}");
      case DioExceptionType.cancel:
        return ApiException("Request to API server was cancelled");
      case DioExceptionType.connectionError:
        return ApiException("Connection error");
      case DioExceptionType.unknown:
        return ApiException("Unexpected error occurred");
      default:
        return ApiException("Something went wrong");
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}
