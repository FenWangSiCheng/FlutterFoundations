import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/config/app_config.dart';
import 'core/injection/injection.dart';
import 'core/widgets/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appConfig = AppConfig.fromEnvironment(platformFlavor: appFlavor);

  await configureDependencies(appConfig);

  runApp(const App());
}
