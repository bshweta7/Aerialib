import 'package:flutter/material.dart';

import 'cached_network_image.dart';

class MediaIcon extends StatelessWidget {
  // Creates tappable media icon
  const MediaIcon(
      this.caption,
      this.mediaUrl,
      this.onTapFunction,
      this.jwt,
      this.code,
      {super.key}
      );

  final String caption;
  final String mediaUrl;
  final GestureTapCallback? onTapFunction;
  final String jwt;
  final String code;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // TODO thumbnail should always be the right size (square)

              // TODO if no connectivity, either show no image or missing image pic if it can't get the actual image
              // AspectRatio(
              //   aspectRatio: 1.0,
              //   child: CachedNetworkImage(
                Expanded( // TODO remove this and add aspect ratio back to make it take the whole space
                  child: CustomizedCachedNetworkImage(mediaUrl),
                ),
              // ),

              Text(
                caption,
                style: const TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                ),
                // TODO styling - dynamically change font size based on the grid size
                // TODO styling - separate text within the card
              ),
            ],
          ),
        ),
      ),
    );
    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
  }
}

// TODO reference media.dart in apeturama
// TODO: Enable swipe down to reload
// TODO will eventually need to call media with jwt auth to ensure permissions
