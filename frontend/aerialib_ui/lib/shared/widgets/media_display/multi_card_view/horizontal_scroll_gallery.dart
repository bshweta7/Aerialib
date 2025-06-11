import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/cards/media_grid_card.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';

class HorizontalScrollGallery extends StatefulWidget {
  final List<MediaIconEntity> mediaList;
  final double height;
  final int itemsPerPage;
  final bool isFullWidth;

  const HorizontalScrollGallery({
    super.key,
    required this.mediaList,
    this.height = 250,
    this.itemsPerPage = -1,
    this.isFullWidth = false,
  });

  @override
  State<HorizontalScrollGallery> createState() =>
      _HorizontalScrollGalleryState();
}

class _HorizontalScrollGalleryState extends State<HorizontalScrollGallery> {
  int _currentPage = 0;

  void _goToPage(int newPage, int totalPages) {
    if (newPage >= 0 && newPage < totalPages) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int itemsPerPage;
    final double itemWidth = widget.isFullWidth ? widget.height : widget.height * 0.65;

    if (widget.itemsPerPage > 0) {
      itemsPerPage = widget.itemsPerPage;
    } else {
      final screenWidth = MediaQuery.of(context).size.width;

      // Estimate width per card including padding/margins
      final cardWidth = itemWidth + 12;
      final availableWidth = screenWidth - 80; // subtract padding + icon buttons
      itemsPerPage = (availableWidth / cardWidth)
          .floor()
          .clamp(1, widget.mediaList.length);
    }

    final totalPages = (widget.mediaList.length / itemsPerPage).ceil();

    final startIndex = _currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage).clamp(0, widget.mediaList.length);
    final currentItems = widget.mediaList.sublist(startIndex, endIndex);

    return Row(
      children: [
        if (totalPages > 1)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _currentPage > 0
                ? () => _goToPage(_currentPage - 1, totalPages)
                : null,
          ),
        Expanded(
          child: SizedBox(
            height: widget.height,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              children: currentItems.map((icon) {
                final showCaption = icon.title != null;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SizedBox(
                    width: itemWidth,
                    child: MediaGridCard(
                      title: icon.title,
                      subtitle: icon.subtitle,
                      mediaUrl: icon.imageUrl,
                      onTapFunction: icon.onTapFunction,
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
                ? () => _goToPage(_currentPage + 1, totalPages)
                : null,
          ),
      ],
    );
  }
}
