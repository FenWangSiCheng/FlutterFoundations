import 'package:flutter/material.dart';
import 'package:flutter_foundations/app_config.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.appName),
      ),
      body: const Center(
        child: Text(
          'Hello ${AppConfig.appName}',
        ),
      ),
    );
  }
}
