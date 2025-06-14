// import '../../domain/entities/flow_entity.dart';
// import 'flow_pose_display_model.dart';
//
// class FlowDisplayModel {
//   final FlowEntity flow;
//   final List<FlowPoseDisplayModel> flowPoses;
//
//   FlowDisplayModel({
//     required this.flow,
//     required this.flowPoses,
//   });
//
//   /// Convenience: ordered by poseOrder
//   List<FlowPoseDisplayModel> get orderedPoses =>
//       [...flowPoses]..sort((a, b) => a.poseOrder.compareTo(b.poseOrder));
//
//   /// Thumbnail from first pose with media, or fallback to flow.primaryMediaPath
//   String get thumbnailPath {
//     for (final pose in orderedPoses) {
//       if (pose.thumbnailPath.isNotEmpty) return pose.thumbnailPath;
//     }
//     return flow.primaryMediaPath ?? '';
//   }
//
//   /// Label, subtitle, or description helpers for cards or lists
//   String get title => flow.name;
//   String get subtitle => '${flow.apparatus} • Level ${flow.level}';
//
//   /// Optional: quick access to IDs
//   String get id => flow.id;
//
// /// Optional: tags, metadata, etc. later
// }
