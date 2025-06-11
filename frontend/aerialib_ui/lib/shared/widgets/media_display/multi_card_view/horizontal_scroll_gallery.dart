import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/cards/media_grid_card.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';

class HorizontalScrollGallery extends StatefulWidget {
  final List<MediaIconEntity> mediaList;
  final double height;
  final int itemsPerPage;

  const HorizontalScrollGallery({
    super.key,
    required this.mediaList,
    this.height = 250,
    this.itemsPerPage = 3, // show 3 cards per view by default
  });

  @override
  State<HorizontalScrollGallery> createState() =>
      _HorizontalScrollGalleryState();
}

class _HorizontalScrollGalleryState extends State<HorizontalScrollGallery> {
  int _currentPage = 0;

  void _goToPage(int newPage) {
    if (newPage >= 0 &&
        newPage < (widget.mediaList.length / widget.itemsPerPage).ceil()) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPages =
    (widget.mediaList.length / widget.itemsPerPage).ceil();

    final startIndex = _currentPage * widget.itemsPerPage;
    final endIndex =
    (startIndex + widget.itemsPerPage).clamp(0, widget.mediaList.length);
    final currentItems = widget.mediaList.sublist(startIndex, endIndex);

    return Row(
      children: [
        if (totalPages > 1)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _currentPage > 0
                ? () => _goToPage(_currentPage - 1)
                : null,
          ),
        Expanded(
          child: SizedBox(
            height: widget.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: currentItems.map((icon) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SizedBox(
                    width: widget.height * 0.65,
                    child: MediaGridCard(
                      caption: icon.title,
                      mediaUrl: icon.imageUrl,
                      onTapFunction: () {
                        // TODO: open transition modal
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (totalPages > 1)
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _currentPage < totalPages - 1
                ? () => _goToPage(_currentPage + 1)
                : null,
          ),
      ],
    );
  }
}
