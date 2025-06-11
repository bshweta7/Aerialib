import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';
import 'package:frontend/shared/widgets/media_display/cards/list_card.dart';

typedef NavigateToMediaPage = void Function(MediaIconEntity mediaItem); // Define the typedef here
typedef ToggleFavorite = void Function(MediaIconEntity mediaItem);

class MediaList extends StatelessWidget {
  final List<MediaIconEntity> mediaItems;
  final NavigateToMediaPage onMediaTap;
  final ScrollController? scrollController; // TODO make this required? since itll be used everywhere anyways...
  final ToggleFavorite? onFavoriteToggle;

  const MediaList({
    super.key,
    required this.mediaItems,
    required this.onMediaTap,
    this.scrollController,
    this.onFavoriteToggle,
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
            title: mediaItem.title!,
            subtitle: mediaItem.subtitle!,
            // only show heart if the param is passed and the item has isFavorite set
            isFavorite: mediaItem.isFavorite,
            onFavoriteToggle: onFavoriteToggle != null
                ? () => onFavoriteToggle!(mediaItem)
                : null,
          ),
        );
      },
      cacheExtent: 600.0, // preload a bit offscreen
    );
  }
}
