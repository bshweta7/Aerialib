import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_cached_network_image.dart';

class MediaIconGridCard extends StatelessWidget {
  // Creates tappable media icon
  const MediaIconGridCard({
    required this.caption,
    required this.mediaUrl,
    this.onTapFunction,
    super.key,
  });

  final String caption;
  final String mediaUrl;
  final GestureTapCallback? onTapFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // TODO thumbnail should always be the right size (square)
          children: [
            // TODO remove this and add aspect ratio back to make it take the whole space
            Expanded(
              child: FormattedCachedNetworkImage(mediaUrl),
            ),
            Text(
              caption,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,

            ),
          ],
        ),
      ),
    );
  }
}
