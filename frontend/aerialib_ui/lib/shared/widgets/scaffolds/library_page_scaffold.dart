import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/shared/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import '../main_scaffold.dart';

class LibraryPageScaffold extends StatelessWidget {
  final String title;
  final int currentIndex;
  final Widget child;
  final ScrollController scrollController;
  // final bool isScrollToTopVisible;
  final VoidCallback? onAddPressed;
  final Widget? filterWidget;
  final Widget? searchWidget;

  const LibraryPageScaffold({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.child,
    required this.scrollController,
    // this.isScrollToTopVisible = false,
    this.onAddPressed,
    this.filterWidget,
    this.searchWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      isScrollable: false,
      currentIndex: currentIndex,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: Text(title),
        actions: [
          if (onAddPressed != null)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add new',
              onPressed: onAddPressed,
            ),
        ],
      ),
      body: Column(
        children: [
          if (searchWidget != null || filterWidget != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  if (searchWidget != null) Expanded(child: searchWidget!),
                  if (filterWidget != null) ...[
                    const SizedBox(width: 10),
                    filterWidget!,
                  ],
                ],
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                child,
                ScrollToTopButton(scrollController: scrollController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onNavTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/flow-library');
        break;
      case 2:
        context.go('/pose-library');
        break;
      case 3:
        context.go('/user-profile');
        break;
    }
  }
}
