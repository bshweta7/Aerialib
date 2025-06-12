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
      isSynced: map['is_synced'] ?? map['isSynced'] ?? 1,
    );
  }

  Map<String, dynamic> toMapLocal() {
    return {
      'id': id,
      'flow_id': flowId,
      'pose_id': poseId,
      'pose_order': poseOrder,
      if (transitionId != null) 'transition_id': transitionId,
      'is_synced': isSynced,
    };
  }

  Map<String, dynamic> toMapRemote() {
    return {
      'id': id,
      'flowId': flowId,
      'poseId': poseId,
      'poseOrder': poseOrder,
      if (transitionId != null) 'transitionId': transitionId,
      'isSynced': isSynced,
    };
  }

  factory FlowPoseModel.fromJson(String source) =>
      FlowPoseModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMapLocal());

  FlowPoseModel copyWith({
    String? id,
    String? flowId,
    String? poseId,
    int? poseOrder,
    String? transitionId,
    int? isSynced,
  }) {
    return FlowPoseModel(
      id: id ?? this.id,
      flowId: flowId ?? this.flowId,
      poseId: poseId ?? this.poseId,
      poseOrder: poseOrder ?? this.poseOrder,
      transitionId: transitionId ?? this.transitionId,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
