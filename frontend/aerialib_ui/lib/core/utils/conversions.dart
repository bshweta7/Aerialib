import '../../domain/entities/media_icon_entity.dart';
import '../../domain/entities/pose_entity.dart';

List<MediaIconEntity> posesToMediaIcons(List<PoseEntity> poses) {
  return poses.map((pose) => MediaIconEntity(
    imageUrl: pose.primaryImageUrl,
    title: pose.name,
    subtitle: "$pose.level", // TODO - adjust the subtitle
    type: MediaType.pose,
    data: pose,
  )).toList();
}