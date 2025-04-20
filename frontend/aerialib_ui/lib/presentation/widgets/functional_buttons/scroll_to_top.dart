import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;
  final double visibleThreshold;
  final double bottomOffset;
  final double rightOffset;
  final String? heroTag;

  const ScrollToTopButton({
    super.key,
    required this.scrollController,
    this.visibleThreshold = 150.0, // Show button after scrolling this much
    this.bottomOffset = 20.0,
    this.rightOffset = 20.0,
    this.heroTag = 'scrollTopFAB',
  });

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController.offset >= widget.visibleThreshold && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
    } else if (widget.scrollController.offset < widget.visibleThreshold && _isVisible) {
      setState(() {
        _isVisible = false;
      });
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink(); // Don't render if not visible
    }

    return Positioned(
      bottom: widget.bottomOffset,
      right: widget.rightOffset,
      child: FloatingActionButton(
        heroTag: widget.heroTag,
        onPressed: _scrollToTop,
        tooltip: 'Scroll to the top of the page',
        child: const Icon(CupertinoIcons.arrow_up),
      ),
    );
  }
}