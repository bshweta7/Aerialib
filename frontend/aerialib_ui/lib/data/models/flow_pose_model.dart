import 'dart:convert';

class FlowPoseModel {
  final String id;
  final String flowId;
  final String poseId;
  final int poseOrder;
  final String? transitionId;
  final int isSynced;

  const FlowPoseModel({
    required this.id,
    required this.flowId,
    required this.poseId,
    required this.poseOrder,
    this.transitionId,
    required this.isSynced,
  });

  factory FlowPoseModel.fromMap(Map<String, dynamic> map) {
    return FlowPoseModel(
      id: map['id'] ?? '',
      flowId: map['flow_id'] ?? map['flowId'] ?? '',
      poseId: map['pose_id'] ?? map['poseId'] ?? '',
      poseOrder: map['pose_order'] ?? map['poseOrder'] ?? -1,
      transitionId: map['transition_id'] ?? map['transitionId'],
      isSynced: map['is_synced'] ?? map['isSynced'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flow_id': flowId,
      'pose_id': poseId,
      'pose_order': poseOrder,
      if (transitionId != null) 'transition_id': transitionId,
      'is_synced': isSynced,
    };
  }

  factory FlowPoseModel.fromJson(String source) =>
      FlowPoseModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
