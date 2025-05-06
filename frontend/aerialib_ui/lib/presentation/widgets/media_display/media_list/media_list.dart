import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/list_card.dart';

typedef NavigateToMediaPage = void Function(MediaIconEntity mediaItem); // Define the typedef here

class MediaList extends StatelessWidget {
  final List<MediaIconEntity> mediaItems;
  final NavigateToMediaPage onMediaTap;
  final ScrollController? scrollController; // TODO make this required? since itll be used everywhere anyways...

  const MediaList({
    super.key,
    required this.mediaItems,
    required this.onMediaTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: mediaItems.length,
      itemBuilder: (context, index) {
        final mediaItem = mediaItems[index];
        return GestureDetector(
          onTap: () => onMediaTap(mediaItem),
          child: ListCard(
            imageUrl: mediaItem.imageUrl,
            title: mediaItem.title,
            subtitle: mediaItem.subtitle,
          ),
        );
      },
      cacheExtent: 600.0, // preload a bit offscreen
    );
  }
}
