import 'package:frontend/features/flow/domain/entities/flow_pose_entity.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/transitions/domain/transition_entity.dart';

class FlowPoseDisplayModel {
  final FlowPoseEntity flowPose;
  final PoseEntity pose;
  final TransitionEntity? transition;

  FlowPoseDisplayModel({
    required this.flowPose,
    required this.pose,
    this.transition,
  });

  /// Convenience getter to expose pose order
  int get poseOrder => flowPose.poseOrder;

  /// Derived name label
  String get label => pose.displayName;

  /// Fallback-safe media path
  String get thumbnailPath => pose.primaryMediaPath;

  /// Factory to build from maps (e.g., Cubit-level)
  factory FlowPoseDisplayModel.fromEntity({
    required FlowPoseEntity flowPose,
    required Map<String, PoseEntity> poseMap,
    required Map<String, TransitionEntity> transitionMap,
  }) {
    final pose = poseMap[flowPose.poseId];
    final transition = flowPose.transitionId != null
        ? transitionMap[flowPose.transitionId!]
        : null;

    if (pose == null) {
      throw Exception(
        '[FlowPoseDisplayModel] Missing pose: ${flowPose.poseId}',
      );
    }

    return FlowPoseDisplayModel(
      flowPose: flowPose,
      pose: pose,
      transition: transition,
    );
  }
}
