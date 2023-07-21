enum Flavor {
  develop,
  staging,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.develop:
        return 'flutter dev';
      case Flavor.staging:
        return 'flutter stg';
      case Flavor.production:
        return 'flutter pro';
      default:
        return 'title';
    }
  }

}
