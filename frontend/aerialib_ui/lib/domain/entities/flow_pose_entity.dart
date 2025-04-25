import 'pose_entity.dart';

class FlowPoseEntity {
  final String id;
  final String flowId;
  final PoseEntity pose;
  final int poseOrder;

  FlowPoseEntity({
    required this.id,
    required this.flowId,
    required this.pose,
    required this.poseOrder,
  });

  FlowPoseEntity copyWith({
    String? id,
    String? flowId,
    PoseEntity? pose,
    int? poseOrder,
  }) {
    return FlowPoseEntity(
      id: id ?? this.id,
      flowId: flowId ?? this.flowId,
      pose: pose ?? this.pose,
      poseOrder: poseOrder ?? this.poseOrder,
    );
  }
}
