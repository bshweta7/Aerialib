import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class FormattedCachedNetworkImage extends StatelessWidget {
  final String mediaUrl;
  final BoxFit fit;

  const FormattedCachedNetworkImage(
      this.mediaUrl, {
        super.key,
        this.fit = BoxFit.cover,
      });

  @override
  Widget build(BuildContext context) {
    final fullUrl = '${Constants.mediaUrlPrefix}/$mediaUrl';
    log('[FormattedCachedNetworkImage] Loading URL: $fullUrl');

    return CachedNetworkImage(
      imageUrl: fullUrl,
      fit: fit,
      placeholderFadeInDuration: const Duration(milliseconds: 300),
      fadeInDuration: const Duration(milliseconds: 300),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
