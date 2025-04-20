import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/presentation/widgets/media_display/media_icon_grid_card.dart';

import 'list_card.dart';

// TODO if the screen is too small, only show name if tapped on ?

class MediaList extends StatelessWidget {
  final List<MediaIconEntity> mediaItems;

  const MediaList({super.key, required this.mediaItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: mediaItems.length,
      itemBuilder: (context, index) {
        print(index);
        final mediaItem = mediaItems[index];
        print(mediaItem.imageUrl);
        return ListCard( // Your existing card widget
          imageUrl: mediaItem.imageUrl,
          title: mediaItem.title,
          subtitle: mediaItem.subtitle,
          // You might handle tap actions or other type-specific logic here
        );
      },
    );
  }
}