import 'package:flutter/material.dart';
import '../formatted_cached_network_image.dart';

class MediaIconGridCard extends StatelessWidget {
  // Creates tappable media icon
  const MediaIconGridCard({
    required this.caption,
    required this.mediaUrl,
    this.onTapFunction,
    Key? key,
  }) : super(key: key);

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
          // TODO if no connectivity, either show no image or missing image pic if it can't get the actual image

          children: [
            // TODO remove this and add aspect ratio back to make it take the whole space
            Expanded(
              child: FormattedCachedNetworkImage(mediaUrl),
            ),
            Text(
              caption,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              // TODO styling - dynamically change font size based on the grid size
              // TODO styling - separate text within the card
            ),
          ],
        ),
      ),
    );
  }
}

// TODO reference media.dart in apeturama
// TODO: Enable swipe down to reload
// TODO will eventually need to call media with jwt auth to ensure permissions
