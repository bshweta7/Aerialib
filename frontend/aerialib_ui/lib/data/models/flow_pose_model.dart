import 'dart:convert';

// TODO missing some fields...

class FlowPoseModel {
  final String id; // Primary Key (UUID)
  final String flowId; // Foreign Key to flow table (UUID)
  final String poseId; // Foreign Key to poses table (UUID)
  final int order; // Position in the flow

  const FlowPoseModel({
    required this.id,
    required this.flowId,
    required this.poseId,
    required this.order,
  });

  factory FlowPoseModel.fromMap(Map<String, dynamic> map) {
    return FlowPoseModel(
      id: map['id'] ?? '',
      flowId: map['flow_id'] ?? '',
      poseId: map['pose_id'] ?? '',
      order: map['order'] ?? -1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flow_id': flowId,
      'pose_id': poseId,
      'order': order,
    };
  }

  factory FlowPoseModel.fromJson(String source) =>
      FlowPoseModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}