// lib/presentation/widgets/common/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:frontend/shared/features/navigation/widgets/nav_bar.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_wrapper.dart';

import 'functional_buttons/scroll_to_top.dart';

// TODO should every page can have a scroll to top button? maybe make an optional arg here that adds it?
class MainScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final PreferredSizeWidget? appBar;
  // final FloatingActionButton? floatingActionButton;
  final bool isScrollable;
  final bool isScrollbarVisible;
  final ScrollController? scrollController;
  final bool isScrollToTopVisible;

  const MainScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    this.appBar,
    // this.floatingActionButton,
    this.isScrollable = true,
    this.isScrollbarVisible = false,
    this.scrollController,
    this.isScrollToTopVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    if (isScrollable) {
      content = Scrollbar(
        controller: scrollController,
        thumbVisibility: isScrollbarVisible,
        interactive: true,
        child: SingleChildScrollView(
          controller: scrollController,
          primary: scrollController == null,
          padding: const EdgeInsets.only(right: 1),
          child: body,
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          content,
          if (scrollController != null && isScrollToTopVisible)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 16),
                child: ScrollToTopButton(scrollController: scrollController!),
              ),
            ),
        ],
      ),
      bottomNavigationBar: NavBar(currentIndex: currentIndex),
      // floatingActionButton: floatingActionButton,
    );
  }
}