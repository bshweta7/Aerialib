import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';
import 'package:frontend/shared/widgets/media_display/cards/media_grid_card.dart';

// TODO if the screen is too small, only show name if tapped on ?

class MediaGrid extends StatelessWidget {
  const MediaGrid({
    required this.mediaList,
    required this.gridSize,
    required this.onTapBuilder,
    Key? key,
  }) : super(key: key);

  final List<MediaIconEntity> mediaList;
  final int gridSize;

  /// Builds the onTap callback for a given media item
  final GestureTapCallback Function(MediaIconEntity media) onTapBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
      ),
      itemBuilder: (context, index) {
        final media = mediaList[index];
        return MediaGridCard(
          title: media.title,
          subtitle: media.subtitle,
          mediaUrl: media.imageUrl,
          onTapFunction: onTapBuilder(media),
        );
      },
      itemCount: mediaList.length,
    );
  }
}
