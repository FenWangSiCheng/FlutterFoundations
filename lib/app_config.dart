class AppConfig {
  static const String appName = String.fromEnvironment('appName');
  static const String baseUrl = String.fromEnvironment('baseUrl');
  static const bool mockApiDataSource = bool.fromEnvironment('mockApiDataSource');
}
