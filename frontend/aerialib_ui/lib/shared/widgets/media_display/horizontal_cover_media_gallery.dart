import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/general/media_item.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_cached_network_image.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_video_player.dart';

class HorizontalCoverMediaGallery extends StatefulWidget {
  final List<MediaItem> mediaList;
  final double height;

  const HorizontalCoverMediaGallery({
    super.key,
    required this.mediaList,
    this.height = 250,
  });

  @override
  State<HorizontalCoverMediaGallery> createState() =>
      _HorizontalCoverMediaGalleryState();
}

class _HorizontalCoverMediaGalleryState extends State<HorizontalCoverMediaGallery> {
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
      return SizedBox(
        height: widget.height,
        child: FormattedVideoPlayer(videoUrl: item.url), // TODO verify that this works
      );
    } else {
      return SizedBox(
        height: widget.height,
        child: FormattedCachedNetworkImage(item.url, fit: BoxFit.contain),
      );
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
        if (media.length > 1)
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

        if (media.length > 1)
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
