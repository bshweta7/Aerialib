// lib/presentation/widgets/common/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/nav_bar.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;

  const MainScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: NavBar(currentIndex: currentIndex),
      floatingActionButton: floatingActionButton,
    );
  }
}
