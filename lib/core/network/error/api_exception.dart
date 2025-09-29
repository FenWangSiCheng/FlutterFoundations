/// Custom API exception with enhanced error information
class ApiException implements Exception {
  final String message;
  final int? errorCode;

  ApiException(this.message, {this.errorCode});

  @override
  String toString() {
    final buffer = StringBuffer('ApiException: $message');
    if (errorCode != null) {
      buffer.write(' (Code: $errorCode)');
    }
    return buffer.toString();
  }

  /// Create ApiException with error code
  factory ApiException.withMessageAndCode(String message, int errorCode) {
    return ApiException(message, errorCode: errorCode);
  }
}
