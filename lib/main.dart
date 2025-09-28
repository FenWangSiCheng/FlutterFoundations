import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';
import 'app_config.dart';

late final AppConfig appConfig;

FutureOr<void> main() async {
  appConfig = AppConfig.fromEnvironment();
  runApp(const App());
}