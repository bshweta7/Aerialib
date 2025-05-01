import 'pose_entity.dart';
import 'transition_entity.dart';

class FlowPoseEntity {
  final String id;
  final String flowId;
  final PoseEntity pose;
  final int poseOrder;
  final TransitionEntity? transition; // now a full object

  FlowPoseEntity({
    required this.id,
    required this.flowId,
    required this.pose,
    required this.poseOrder,
    this.transition,
  });

  FlowPoseEntity copyWith({
    String? id,
    String? flowId,
    PoseEntity? pose,
    int? poseOrder,
    TransitionEntity? transition,
  }) {
    return FlowPoseEntity(
      id: id ?? this.id,
      flowId: flowId ?? this.flowId,
      pose: pose ?? this.pose,
      poseOrder: poseOrder ?? this.poseOrder,
      transition: transition ?? this.transition,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FlowPoseEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              flowId == other.flowId &&
              pose == other.pose &&
              poseOrder == other.poseOrder &&
              transition == other.transition;

  @override
  int get hashCode =>
      id.hashCode ^
      flowId.hashCode ^
      pose.hashCode ^
      poseOrder.hashCode ^
      transition.hashCode;
}
