import '../../pose/domain/entities/pose_entity.dart';
import '../domain/entities/transition_entity.dart';

class TransitionDisplayModel {
  final TransitionEntity transition;
  final PoseEntity fromPose;
  final PoseEntity toPose;

  TransitionDisplayModel({
    required this.transition,
    required this.fromPose,
    required this.toPose,
  });

  String get label => '${fromPose.displayName} → ${toPose.displayName}';

  String get thumbnailPath =>
      toPose.primaryMediaPath.isNotEmpty ? toPose.primaryMediaPath : fromPose.primaryMediaPath;

  factory TransitionDisplayModel.fromEntity(
      TransitionEntity transition,
      Map<String, PoseEntity> poseMap,
      ) {
    return TransitionDisplayModel(
      transition: transition,
      fromPose: poseMap[transition.fromPoseId]!,
      toPose: poseMap[transition.toPoseId]!,
    );
  }

// Add more derived fields if needed
}
