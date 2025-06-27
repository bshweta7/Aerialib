// lib/presentation/widgets/common/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:frontend/shared/features/navigation/widgets/nav_bar.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_wrapper.dart';

// TODO should every page can have a scroll to top button? maybe make an optional arg here that adds it?
class MainScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;
  final bool isScrollable;
  final bool isScrollbarVisible;

  const MainScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.appBar,
    this.floatingActionButton,
    this.isScrollable = true,
    this.isScrollbarVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    final scrollableBody = isScrollable
        ? Scrollbar(
      thumbVisibility: isScrollbarVisible,
      interactive: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 1),
        child: body,
      ),
    )
        : body;

    return Scaffold(
      appBar: appBar,
      body: scrollableBody,
      bottomNavigationBar: NavBar(currentIndex: currentIndex),
      floatingActionButton: floatingActionButton,
    );
  }
}
