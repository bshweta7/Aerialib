import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_cached_network_image.dart';

class MediaGridCard extends StatelessWidget {
  final String caption;
  final String mediaUrl;
  final GestureTapCallback? onTapFunction;

  const MediaGridCard({
    super.key,
    required this.caption,
    required this.mediaUrl,
    this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Card(
        margin: const EdgeInsets.all(6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: FormattedCachedNetworkImage(mediaUrl),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Tooltip(
                message: caption,
                waitDuration: const Duration(milliseconds: 400),
                child: Text(
                  caption,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
