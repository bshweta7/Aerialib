class MediaItem {
  final String url;
  final bool isVideo;

  MediaItem({required this.url, this.isVideo = false});
}
// TODO figure out how to combine this with mediaIconEntity (and if i should or not...)


// class MediaItem {
//   final String url;
//   final bool? isVideo;
//   final String? title;
//   final String? subtitle;
//   final MediaType type; // Enum to differentiate between Flow and Pose and Music and Media
//   final dynamic data; // Holds the original object (e.g., FlowEntity, PoseEntity, etc.)
//   final bool? isFavorite;
//
//   MediaItem({
//     required this.url,
//     this.isVideo = false,
//     required this.title,
//     required this.subtitle,
//     required this.type,
//     this.data,
//     this.isFavorite,
//   });
// }
//
// enum MediaType {
//   pose,
//   flow,
//   media,
//   music,
// }