import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_cached_network_image.dart';

class MediaGridCard extends StatelessWidget {
  final String mediaUrl;
  final String? caption; // TODO see list card
  final GestureTapCallback? onTapFunction;

  const MediaGridCard({
    super.key,
    required this.mediaUrl,
    this.caption,
    this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    final hasCaption = caption != null && caption!.trim().isNotEmpty;

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
          mainAxisSize: MainAxisSize.min, // ⬅️ prevent Column from forcing extra space
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: FormattedCachedNetworkImage(mediaUrl),

              // TODO verify if it's a video and do formatted video instead (ref below):
              // HorizontalScrollGallery(
              //   height: screenHeight * 0.4,
              //   items: mediaItems.map((item) {
              //     if (item.url.endsWith('.mp4')) {
              //       return SizedBox(
              //         height: screenHeight * 0.4,
              //         child: FormattedVideoPlayer(videoUrl: item.url),
              //       );
              //     } else {
              //       return SizedBox(
              //         height: screenHeight * 0.4,
              //         child: FormattedCachedNetworkImage(item.url, fit: BoxFit.contain),
              //       );
              //     }
              //   }).toList(),
              // ),
            ),

            if (hasCaption)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Tooltip(
                  message: caption!,
                  waitDuration: const Duration(milliseconds: 400),
                  child: Text(
                    caption!,
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
