import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/media_entity.dart';

List<MediaIconEntity> posesToMediaIcons(List<PoseEntity> poses) {
  return poses.map((pose) => MediaIconEntity(
    imageUrl: "/${pose.primaryMediaPath}",
    title: pose.name,
    subtitle: "Level ${pose.level} | ${capitalizeFirstLetter(pose.apparatus)}", // TODO - adjust the subtitle with tags
    type: MediaType.pose,
    data: pose,
  )).toList();
}


List<MediaIconEntity> flowsToMediaIcons(List<FlowEntity> flows) {
  return flows.map((flow) {
    // For now: use missingImageUrl (can later use flow.poses[0].pose.primaryImageUrl if you want dynamic images)
    return MediaIconEntity(
      imageUrl: "/${flow.thumbnailImagePath}",
      title: flow.name,
      subtitle: capitalizeFirstLetter(flow.apparatus), //TODO
      type: MediaType.flow, // You may want to add this enum if you haven't already
      data: flow,
    );
  }).toList();
}

List<MediaIconEntity> mediaToMediaIcons(List<MediaEntity> mediaList) {
  return mediaList.map((media) {
    return MediaIconEntity(
      imageUrl: "/${media.path}", // or media.filePath depending on your model
      title: media.name ?? 'Untitled', // fallback if name is null
      subtitle: "", // TODO or use tags/metadata if available
      type: MediaType.media,
      data: media,
    );
  }).toList();
}
