import '../../../pose/domain/entities/pose_entity.dart';
import '../../../transitions/domain/transition_entity.dart';

class FlowPoseEntity {
  final String id;
  final String flowId;
  final PoseEntity pose;
  final int poseOrder;
  final TransitionEntity? transition;
  final int isSynced;

  const FlowPoseEntity({
    required this.id,
    required this.flowId,
    required this.pose,
    required this.poseOrder,
    this.transition,
    required this.isSynced,
  });

  FlowPoseEntity copyWith({
    String? id,
    String? flowId,
    String? poseId,
    int? poseOrder,
    String? transitionId,
    int? isSynced,
  }) {
    return FlowPoseEntity(
      id: id ?? this.id,
      flowId: flowId ?? this.flowId,
      pose: pose ?? this.pose,
      poseOrder: poseOrder ?? this.poseOrder,
      transition: transition ?? this.transition,
      isSynced: isSynced ?? this.isSynced,
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
              transition == other.transition &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      flowId.hashCode ^
      pose.hashCode ^
      poseOrder.hashCode ^
      transition.hashCode ^
      isSynced.hashCode;
}
