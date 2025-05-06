import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/core/constants/constants.dart';

class FormattedCachedNetworkImage extends StatelessWidget {
  // Creates tappable media icon
  const FormattedCachedNetworkImage(
      this.mediaUrl,
      {super.key}
      );

  final String mediaUrl;

  @override
  Widget build(BuildContext context) {
    final fullUrl = Constants.mediaUrlPrefix + mediaUrl;
    print('[FormattedCachedNetworkImage] Loading URL: $fullUrl');

    return CachedNetworkImage(
      // TODO see below code for authenticated images (permissions):
      // httpHeaders: { HttpHeaders.authorizationHeader: 'Bearer ' + jwt },
      // imageUrl: poses.thumbnailURL + (code.isEmpty ? "" : "?code=" + code), (// TODO if adding code back in...
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
    );
  }
}
