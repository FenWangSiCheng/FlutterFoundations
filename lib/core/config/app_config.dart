enum Flavor { dev, stg, prod }

class AppConfig {
  final Flavor currentFlavor;

  const AppConfig({required this.currentFlavor});

  factory AppConfig.fromEnvironment({String? platformFlavor}) {
    const definedFlavor = String.fromEnvironment('flavor');
    if (definedFlavor.isNotEmpty &&
        platformFlavor != null &&
        definedFlavor.toLowerCase() != platformFlavor.toLowerCase()) {
      throw StateError(
        'Build flavor ($platformFlavor) differs from dart-define flavor ($definedFlavor)',
      );
    }
    final flavorString = definedFlavor.isNotEmpty
        ? definedFlavor
        : platformFlavor;
    if (flavorString == null || flavorString.isEmpty) {
      throw StateError(
        'Missing flavor. Use --flavor and dart-define-from-file.',
      );
    }
    return AppConfig(currentFlavor: _parseFlavorFromString(flavorString));
  }

  String get appName => switch (currentFlavor) {
    Flavor.dev => 'Flutter Foundations Dev',
    Flavor.stg => 'Flutter Foundations Stg',
    Flavor.prod => 'Flutter Foundations',
  };

  String get baseUrl => switch (currentFlavor) {
    Flavor.dev => 'https://api-dev.example.com',
    Flavor.stg => 'https://api-staging.example.com',
    Flavor.prod => 'https://api.example.com',
  };

  bool get mockApiDataSource => currentFlavor == Flavor.dev;

  bool get isNeedProxy => currentFlavor != Flavor.prod;

  String get flavorName => currentFlavor.name;

  String get flavorTitle => 'flutter ${currentFlavor.name}';

  bool get isProduction => currentFlavor == Flavor.prod;
}

Flavor _parseFlavorFromString(String flavorString) {
  switch (flavorString.toLowerCase()) {
    case 'dev':
      return Flavor.dev;
    case 'stg':
      return Flavor.stg;
    case 'prod':
      return Flavor.prod;
    default:
      throw ArgumentError.value(flavorString, 'flavor', 'Unsupported flavor');
  }
}
