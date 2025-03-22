import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class MediaIcon extends StatelessWidget {
  const MediaIcon(
      this.caption,
      this.mediaUrl,
      this.jwt,
      this.code,
      {super.key}
      );

  final String caption;
  final String mediaUrl;
  final String jwt;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // TODO thumbnail should always be the right size (square)

            // TODO if no connectivity, either show no image or missing image pic if it can't get the actual image
            Expanded(
              child:
              CachedNetworkImage(
                // TODO see below code for authenticated images (permissions):
                // httpHeaders: { HttpHeaders.authorizationHeader: 'Bearer ' + jwt },
                // imageUrl: poses.thumbnailURL + (code.isEmpty ? "" : "?code=" + code),
                // imageUrl: 'http://localhost:8000/media/data/testing/clock.jpg',
                  imageUrl: Constants.mediaUrlPrefix + mediaUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress
                          )
                      ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    );
                  }
              ),
            ),

            Text(
              caption,
              style: const TextStyle(
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
              // TODO styling - dynamically change font size based on the grid size
              // TODO styling - separate text within the card
            ),

            const SizedBox(height: 10)
          ],
        ),
      ),
    );
    //   progressIndicatorBuilder: (context, url, downloadProgress) =>
  }
}

// TODO reference media.dart in apeturama
// TODO: Enable swipe down to reload
// TODO will eventually need to call media with jwt auth to ensure permissions
