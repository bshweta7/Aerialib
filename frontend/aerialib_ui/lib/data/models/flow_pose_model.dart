import 'dart:convert';

// TODO missing some fields...

class FlowPoseModel {
  final String id; // Primary Key (UUID)
  final String flowId; // Foreign Key to flow table (UUID)
  final String poseId; // Foreign Key to poses table (UUID)
  final int poseOrder; // Position in the flow
  final String transitionId;
  final int isSynced;

  const FlowPoseModel({
    required this.id,
    required this.flowId,
    required this.poseId,
    required this.poseOrder,
    required this.transitionId,
    required this.isSynced,
  });

  factory FlowPoseModel.fromMap(Map<String, dynamic> map) {
    return FlowPoseModel(
      id: map['id'] ?? '',
      flowId: map['flow_id'] ?? '',
      poseId: map['pose_id'] ?? '',
      poseOrder: map['pose_order'] ?? -1,
      transitionId: map['transition_id'] ?? '',
      isSynced: map['is_synced'] ?? 0, // Default to synced if not present
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flow_id': flowId,
      'pose_id': poseId,
      'pose_order': poseOrder,
      'transition_id': transitionId,
      'is_synced': isSynced,
    };
  }

  factory FlowPoseModel.fromJson(String source) =>
      FlowPoseModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}