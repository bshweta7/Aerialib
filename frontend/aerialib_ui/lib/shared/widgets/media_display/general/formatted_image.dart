import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class FormattedImage extends StatelessWidget {
  final String mediaUrl;
  final BoxFit fit;
  final bool zoomEnabled;

  const FormattedImage(
      this.mediaUrl, {
        super.key,
        this.fit = BoxFit.cover,
        this.zoomEnabled = false,
      });

  @override
  Widget build(BuildContext context) {
    final fullUrl = '${Constants.mediaUrlPrefix}/$mediaUrl';
    final imageProvider = ExtendedNetworkImageProvider(fullUrl, cache: true);
    // log('[FormattedCachedNetworkImage] Loading URL: $fullUrl');

    return ExtendedImage(
      image: imageProvider,
      fit: fit,
      mode: zoomEnabled ? ExtendedImageMode.gesture : ExtendedImageMode.none,
      initGestureConfigHandler: zoomEnabled
          ? (state) => GestureConfig(
        minScale: 1.0,
        maxScale: 4.0,
        speed: 1.0,
        inertialSpeed: 100.0,
        initialScale: 1.0,
        inPageView: false,
      )
          : null,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(color: Colors.white),
            );
          // case LoadState.failed:
          //   return const Icon(Icons.error);
          case LoadState.failed:
            return GestureDetector(
              onTap: () => state.reLoadImage(),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, color: Colors.grey),
                  SizedBox(height: 8),
                  Center(child: Text("Tap to retry", style: TextStyle(color: Colors.grey))),
                ],
              ),
            );
          case LoadState.completed:
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: state.imageProvider,
                  fit: fit,
                ),
              ),
            );
        }
      },
    );
  }
}
