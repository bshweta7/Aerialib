import 'package:flutter/cupertino.dart';

class MediaIconEntity {
  final String imageUrl;
  final String? title;
  final String? subtitle;
  final MediaType? type; // Enum to differentiate between Flow and Pose and Music and Media
  final dynamic data; // Holds the original object (e.g., FlowEntity, PoseEntity, etc.)
  final bool? isFavorite;
  final GestureTapCallback? onTapFunction;

  MediaIconEntity({
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.type,
    this.data,
    this.isFavorite,
    this.onTapFunction,
  });
}

enum MediaType {
  pose,
  flow,
  media,
  music,
}