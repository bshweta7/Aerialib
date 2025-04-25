import 'pose_entity.dart';

class FlowPoseEntity {
  final String id;
  final String flowId;
  final PoseEntity pose;
  final int order;

  FlowPoseEntity({
    required this.id,
    required this.flowId,
    required this.pose,
    required this.order,
  });

  FlowPoseEntity copyWith({
    String? id,
    String? flowId,
    PoseEntity? pose,
    int? order,
  }) {
    return FlowPoseEntity(
      id: id ?? this.id,
      flowId: flowId ?? this.flowId,
      pose: pose ?? this.pose,
      order: order ?? this.order,
    );
  }
}
