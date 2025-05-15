import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class FormattedCachedNetworkImage extends StatelessWidget {
  const FormattedCachedNetworkImage(this.mediaUrl, {super.key});

  final String mediaUrl;

  @override
  Widget build(BuildContext context) {
    final fullUrl = Constants.mediaUrlPrefix + mediaUrl;
    // /////////print('[FormattedCachedNetworkImage] Loading URL: $fullUrl');

    return CachedNetworkImage(
      imageUrl: fullUrl,
      placeholderFadeInDuration: const Duration(milliseconds: 300),
      fadeInDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
      ),

      errorWidget: (context, url, error) => const Icon(Icons.error),
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover, // better for square thumbnails
            ),
          ),
        );
      },
    );
  }
}
