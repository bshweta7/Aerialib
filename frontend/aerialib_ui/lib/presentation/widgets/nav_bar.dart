// lib/presentation/widgets/common/nav_bar.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  // final String username;

  const NavBar({
    super.key,
    required this.currentIndex,
    // required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.goNamed('home');
            break;
          case 1:
            context.goNamed('flow-library');
            break;
          case 2:
            context.goNamed('pose-library');
            break;
          case 3:
            context.goNamed('user-profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.loop),
          label: 'Flows',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.accessibility),
          label: 'Poses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
