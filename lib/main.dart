import 'dart:async';
import 'package:flutter/material.dart';
import 'core/widgets/app.dart';
import 'core/config/app_config.dart';
import 'core/injection/injection.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appConfig = AppConfig.fromEnvironment();

  // Initialize dependency injection with AppConfig
  await configureDependencies(appConfig);

  runApp(const App());
}