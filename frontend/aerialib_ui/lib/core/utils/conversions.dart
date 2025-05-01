import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/core/constants/constants.dart';

List<MediaIconEntity> posesToMediaIcons(List<PoseEntity> poses) {
  return poses.map((pose) => MediaIconEntity(
    imageUrl: pose.primaryMediaPath,
    title: pose.name,
    subtitle: "Level ${pose.level} | ${pose.apparatus}", // TODO - adjust the subtitle with tags
    type: MediaType.pose,
    data: pose,
  )).toList();
}


List<MediaIconEntity> flowsToMediaIcons(List<FlowEntity> flows) {
  return flows.map((flow) {
    // For now: use missingImageUrl (can later use flow.poses[0].pose.primaryImageUrl if you want dynamic images)
    return MediaIconEntity(
      imageUrl: Constants.missingImagePath, // TODO
      title: flow.name,
      subtitle: flow.apparatus != null ? "${flow.apparatus}" : "", // You can adjust this later
      type: MediaType.flow, // You may want to add this enum if you haven't already
      data: flow,
    );
  }).toList();
}