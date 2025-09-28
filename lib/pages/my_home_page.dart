import 'package:flutter/material.dart';
import '../main.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appConfig.appName),
      ),
      body: Center(
        child: Text(
          'Hello ${appConfig.appName}',
        ),
      ),
    );
  }
}
