import 'package:flutter/material.dart';

class HorizontalScrollGallery extends StatefulWidget {
  final List<Widget> items;
  final double height;

  const HorizontalScrollGallery({
    super.key,
    required this.items,
    this.height = 250,
  });

  @override
  State<HorizontalScrollGallery> createState() =>
      _HorizontalScrollGalleryState();
}

class _HorizontalScrollGalleryState extends State<HorizontalScrollGallery> {
  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  void _goToPage(int index) {
    if (index >= 0 && index < widget.items.length) {
      setState(() => _currentIndex = index);
      _controller.jumpToPage(index);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    return Row(
      children: [
        if (items.length > 1)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed:
            _currentIndex > 0 ? () => _goToPage(_currentIndex - 1) : null,
          ),
        Expanded(
          child: SizedBox(
            height: widget.height,
            child: AbsorbPointer(
              child: PageView.builder(
                controller: _controller,
                itemCount: items.length,
                itemBuilder: (_, index) => items[index],
              ),
            ),
          ),
        ),
        if (items.length > 1)
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _currentIndex < items.length - 1
                ? () => _goToPage(_currentIndex + 1)
                : null,
          ),
      ],
    );
  }
}
