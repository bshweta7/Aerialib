import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';

List<MediaIconEntity> posesToMediaIcons(List<PoseEntity> poses) {
  return poses.map((pose) => MediaIconEntity(
    imageUrl: pose.primaryImageUrl,
    title: pose.name,
    subtitle: "Level ${pose.level} | ${pose.apparatus}", // TODO - adjust the subtitle with tags
    type: MediaType.pose,
    data: pose,
  )).toList();
}