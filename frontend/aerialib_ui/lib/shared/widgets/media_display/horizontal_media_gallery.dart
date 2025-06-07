import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/media_item.dart';
import 'package:frontend/shared/widgets/media_display/formatted_cached_network_image.dart';
import 'package:frontend/shared/widgets/media_display/formatted_video_player.dart';

import 'formatted_cached_network_image.dart';

class HorizontalMediaGallery extends StatefulWidget {
  final List<MediaItem> mediaList;

  const HorizontalMediaGallery({super.key, required this.mediaList});

  @override
  State<HorizontalMediaGallery> createState() => _HorizontalMediaGalleryState();
}

class _HorizontalMediaGalleryState extends State<HorizontalMediaGallery> {
  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  void _goToPage(int index) {
    if (index >= 0 && index < widget.mediaList.length) {
      setState(() => _currentIndex = index);
      _controller.jumpToPage(index);
    }
  }

  Widget _buildMediaItem(MediaItem item) {
    if (item.url.toLowerCase().endsWith('.mp4')) {
      return FormattedVideoPlayer(videoUrl: item.url); // TODO Verify this works
    } else {
      return FormattedCachedNetworkImage(item.url);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = widget.mediaList;

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _currentIndex > 0 ? () => _goToPage(_currentIndex - 1) : null,
        ),
        Expanded(
          child: SizedBox(
            height: 250,
            child: AbsorbPointer(
              child: PageView.builder(
                controller: _controller,
                itemCount: media.length,
                itemBuilder: (_, index) => _buildMediaItem(media[index]),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: _currentIndex < media.length - 1
              ? () => _goToPage(_currentIndex + 1)
              : null,
        ),
      ],
    );
  }
}
