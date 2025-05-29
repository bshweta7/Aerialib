import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/media_entity.dart';

import 'package:frontend/domain/entities/music_entity.dart';
import 'package:frontend/core/constants/constants.dart';

List<MediaIconEntity> posesToMediaIcons(List<PoseEntity> poses) {
  return poses.map((pose) => MediaIconEntity(
    imageUrl: "/${pose.primaryMediaPath}",
    title: pose.name,
    subtitle: "Level ${pose.level} | ${capitalizeFirstLetter(pose.apparatus)}", // TODO - adjust the subtitle with tags
    type: MediaType.pose,
    data: pose,
  )).toList();
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
    final useDefault = flow.thumbnailImagePath == Constants.missingImagePath;
    final defaultPath = "/${Constants.defaultFlowThumbnails[index % Constants.defaultFlowThumbnails.length]}";

    return MediaIconEntity(
      title: flow.name,
      subtitle: 'Level ${flow.level} | ${capitalizeFirstLetter(flow.apparatus)}',
      imageUrl: useDefault ? defaultPath : flow.thumbnailImagePath,
      data: flow,
      type: MediaType.flow,
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
      isFavorite: music.favorite, // ✅ Added here
    );
  }).toList();
}


