class MediaIcon {
  final String title;
  final String imageUrl;
  final String subtitle;
  final String caption;

  MediaIcon({
    required this.title,
    required this.imageUrl,
    this.subtitle = "",
    this.caption = "",
  });
}
