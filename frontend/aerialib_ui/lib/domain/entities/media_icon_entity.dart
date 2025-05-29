class MediaIconEntity {
  final String imageUrl;
  final String title;
  final String subtitle;
  final MediaType type; // Enum to differentiate between Flow and Pose and Music and Media
  final dynamic data; // Holds the original object (e.g., FlowEntity, PoseEntity, etc.)
  final bool? isFavorite;

  MediaIconEntity({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.type,
    this.data,
    this.isFavorite,
  });
}

enum MediaType {
  pose,
  flow,
  media,
  music,
}