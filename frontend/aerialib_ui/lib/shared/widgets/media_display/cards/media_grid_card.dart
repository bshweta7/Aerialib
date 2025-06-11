import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_cached_network_image.dart';

import '../../../../core/constants/app_theme.dart';

class MediaGridCard extends StatelessWidget {
  final String mediaUrl;
  final String? title;
  final String? subtitle;
  final GestureTapCallback? onTapFunction;

  const MediaGridCard({
    super.key,
    required this.mediaUrl,
    this.title,
    this.subtitle,
    this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    final showBottom = (title != null && title!.trim().isNotEmpty) ||
        (subtitle != null && subtitle!.trim().isNotEmpty);

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

            if (showBottom)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Tooltip(
                  message: subtitle == null ? title : "$subtitle From $title",
                  waitDuration: const Duration(milliseconds: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (title != null && title!.trim().isNotEmpty)
                        Text(
                          title!,
                          style: appTextTheme.labelMedium,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}