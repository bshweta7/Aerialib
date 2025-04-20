import '../../domain/entities/media_icon_entity.dart';
import '../../domain/entities/pose_entity.dart';
import '../constants/constants.dart';

List<MediaIconEntity> posesToMediaIcons(List<PoseEntity> poses) {
  return poses.map((pose) => MediaIconEntity(
    imageUrl: "https://aerialib.com/data${pose.primaryImageUrl}", //${Constants.backendUri}
    title: pose.name,
    subtitle: "Level ${pose.level} | ${pose.apparatus}", // TODO - adjust the subtitle with tags
    type: MediaType.pose,
    data: pose,
  )).toList();
}