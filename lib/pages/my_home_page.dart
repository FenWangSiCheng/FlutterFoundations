import 'package:flutter/material.dart';
import 'package:flutter_foundations/consts.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Consts.appName),
      ),
      body: const Center(
        child: Text(
          'Hello ${Consts.appName}',
        ),
      ),
    );
  }
}
