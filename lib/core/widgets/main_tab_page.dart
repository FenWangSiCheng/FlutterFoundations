import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../router/router_constants.dart';

class MainTabPage extends StatelessWidget {
  const MainTabPage({
    super.key,
    required this.currentIndex,
    required this.userPage,
  });

  final int currentIndex;
  final Widget userPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentIndex == 0 ? const HomePage() : userPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) =>
            context.go(index == 0 ? RouterPaths.home : RouterPaths.user),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        ],
      ),
    );
  }
}
