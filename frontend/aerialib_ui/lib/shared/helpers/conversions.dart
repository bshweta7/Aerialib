import 'package:flutter/cupertino.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
import 'package:frontend/features/media/domain/entities/media_entity.dart';

import 'package:frontend/features/music/domain/entities/music_entity.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:go_router/go_router.dart';

import '../../features/transitions/domain/transition_entity.dart';
import '../../features/transitions/presentation/pages/transition_view_page.dart';

List<MediaIconEntity> posesToMediaIcons(
    List<PoseEntity> poses,
    {void Function(PoseEntity pose)? onTap}
  ) {
  return poses.map((pose) => MediaIconEntity(
    imageUrl: "/${pose.primaryMediaPath}",
    title: pose.displayName,
    subtitle: "Level ${pose.level} | ${capitalizeFirstLetter(pose.apparatus)}", // TODO - adjust the subtitle with tags
    type: MediaType.pose,
    data: pose,
    onTapFunction: onTap != null ? () => onTap(pose) : null,
    // TODO add is_favorite
  )).toList();
}

List<MediaIconEntity> transitionPosesToMediaIcons({
  required List<TransitionEntity> transitions,
  required Map<String, PoseEntity> poseMap,
  void Function(TransitionEntity transition)? onTap,
}) {
  return transitions.map((transition) {
    final fromPose = poseMap[transition.fromPoseId];
    if (fromPose == null) return null;

    return MediaIconEntity(
      imageUrl: "/${fromPose.primaryMediaPath}",
      title: fromPose.displayName,
      subtitle: transition.name,
      type: MediaType.transition,
      data: transition,
      onTapFunction: onTap != null ? () => onTap(transition) : null,
    );
  }).whereType<MediaIconEntity>().toList();
}



// List<MediaIconEntity> flowsToMediaIcons(List<FlowEntity> flows) {
//   return flows.map((flow) {
//     // For now: use missingImageUrl (can later use flow.poses[0].pose.primaryImageUrl if you want dynamic images)
//     return MediaIconEntity(
//       imageUrl: "/${flow.thumbnailImagePath}",
//       title: flow.name,
//       subtitle: capitalizeFirstLetter(flow.apparatus), //TODO
//       type: MediaType.flow, // You may want to add this enum if you haven't already
//       data: flow,
//     );
//   }).toList();
// }

List<MediaIconEntity> flowsToMediaIcons(List<FlowEntity> flows) {
  return flows.asMap().entries.map((entry) {
    final index = entry.key;
    final flow = entry.value;

    // If missing, pick an alternating default image
    final useDefault = flow.primaryMediaPath == Constants.missingImagePath;
    final defaultPath = "/${Constants.defaultFlowThumbnails[index % Constants.defaultFlowThumbnails.length]}";

    return MediaIconEntity(
      title: flow.name,
      subtitle: 'Level ${flow.level} | ${capitalizeFirstLetter(flow.apparatus)}',
      imageUrl: useDefault ? defaultPath : flow.primaryMediaPath!,
      data: flow,
      type: MediaType.flow,
    );
  }).toList();
}

List<MediaIconEntity> mediaToMediaIcons(List<MediaEntity> mediaList) {
  return mediaList.map((media) {
    return MediaIconEntity(
      imageUrl: "/${media.mediaPath}", // or media.filePath depending on your model
      title: media.name ?? 'Untitled', // fallback if name is null
      subtitle: "", // TODO or use tags/metadata if available
      type: MediaType.media,
      data: media,
    );
  }).toList();
}

List<MediaIconEntity> musicToMediaIcons(List<MusicEntity> musicList) {
  return musicList.asMap().entries.map((entry) {
    final index = entry.key;
    final music = entry.value;

    final defaultPath = "/${Constants.defaultMusicThumbnails[index % Constants.defaultMusicThumbnails.length]}";

    return MediaIconEntity(
      title: music.name,
      subtitle: [
        if (music.mood?.isNotEmpty == true) capitalizeFirstLetter(music.mood!),
        if (music.artist?.isNotEmpty == true) music.artist!,
      ].join(" • "),
      imageUrl: defaultPath,
      data: music,
      type: MediaType.music,
      isFavorite: music.favorite,
    );
  }).toList();
}


