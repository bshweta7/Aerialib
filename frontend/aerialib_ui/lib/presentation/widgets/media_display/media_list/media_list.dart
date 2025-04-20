import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/list_card.dart';

typedef NavigateToMediaPage = void Function(MediaIconEntity mediaItem); // Define the typedef here

class MediaList extends StatelessWidget {
  final List<MediaIconEntity> mediaItems;
  final NavigateToMediaPage onMediaTap;

  const MediaList({super.key, required this.mediaItems, required this.onMediaTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: mediaItems.length,
      // TODO if itemCount = 0, say "Oops, no poses found. Try changing your filters!"
      itemBuilder: (context, index) {
        final mediaItem = mediaItems[index];
        return GestureDetector(
          onTap: () {
            onMediaTap(mediaItem);
          },
          child: ListCard(
            imageUrl: mediaItem.imageUrl,
            title: mediaItem.title,
            subtitle: mediaItem.subtitle,
          ),
        );
      },
    );
  }
}