import 'dart:async';
import 'package:flutter/material.dart';
import 'core/widgets/app.dart';
import 'core/config/app_config.dart';
import 'core/injection/injection.dart';

late final AppConfig appConfig;

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appConfig = AppConfig.fromEnvironment();

  // Initialize dependency injection
  await configureDependencies();

  runApp(const App());
}