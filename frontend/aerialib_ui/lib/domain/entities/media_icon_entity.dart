class MediaIconEntity {
  final String imageUrl;
  final String title;
  final String subtitle;
  final MediaType type; // Enum to differentiate between Flow and Pose
  final dynamic data; // TODO - Optional: Hold the original Flow or Pose object if needed for specific actions

  // TODO add alt text

  MediaIconEntity({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.type,
    this.data,
  });
}

enum MediaType {
  pose,
  flow,
  media,
}