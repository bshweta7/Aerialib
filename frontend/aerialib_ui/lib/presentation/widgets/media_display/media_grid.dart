import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/media_icon.dart';
import 'package:frontend/presentation/widgets/media_display/media_icon_grid_card.dart';

// TODO if the screen is too small, only show name if tapped on ?

class MediaGrid extends StatelessWidget {
  const MediaGrid({
    required this.mediaList,
    required this.gridSize,
    required this.onTapBuilder,
    Key? key,
  }) : super(key: key);

  final List<MediaIcon> mediaList;
  final int gridSize;

  /// Builds the onTap callback for a given media item
  final GestureTapCallback Function(MediaIcon media) onTapBuilder;

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
        return MediaIconGridCard(
          caption: media.title,
          mediaUrl: media.imageUrl,
          onTapFunction: onTapBuilder(media),
        );
      },
      itemCount: mediaList.length,
    );
  }
}
