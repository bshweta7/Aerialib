class FlowPoseEntity {
  final String id;
  final String flowId;
  final String poseId;
  final int poseOrder;
  final String? transitionId;
  final int isSynced;

  const FlowPoseEntity({
    required this.id,
    required this.flowId,
    required this.poseId,
    required this.poseOrder,
    this.transitionId,
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
      poseId: poseId ?? this.poseId,
      poseOrder: poseOrder ?? this.poseOrder,
      transitionId: transitionId ?? this.transitionId,
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
              poseId == other.poseId &&
              poseOrder == other.poseOrder &&
              transitionId == other.transitionId &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      flowId.hashCode ^
      poseId.hashCode ^
      poseOrder.hashCode ^
      transitionId.hashCode ^
      isSynced.hashCode;
}
