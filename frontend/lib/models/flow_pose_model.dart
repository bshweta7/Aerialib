import 'dart:convert';

class FlowPoseModel {
  final String id;
  final String flowId;
  final String poseId;
  final int order;
  final String? transitionId;
  final int isSynced;

  FlowPoseModel({
    required this.id,
    required this.flowId,
    required this.poseId,
    required this.order,
    this.transitionId,
    required this.isSynced,
  });

  FlowPoseModel copyWith({
    String? id,
    String? flowId,
    String? poseId,
    int? order,
    String? transitionId,
    int? isSynced,
  }) {
    return FlowPoseModel(
      id: id ?? this.id,
      flowId: flowId ?? this.flowId,
      poseId: poseId ?? this.poseId,
      order: order ?? this.order,
      transitionId: transitionId ?? this.transitionId,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'flowId': flowId,
      'poseId': poseId,
      'order': order,
      'transitionId': transitionId,
      'isSynced': isSynced,
    };
  }

  factory FlowPoseModel.fromMap(Map<String, dynamic> map) {
    return FlowPoseModel(
      id: map['id'] ?? '',
      flowId: map['flowId'] ?? '',
      poseId: map['poseId'] ?? '',
      order: map['order'] ?? -1,
      transitionId: map['transitionId'],
      isSynced: map['isSynced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory FlowPoseModel.fromJson(String source) =>
      FlowPoseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FlowPoseModel('
        'id: $id, '
        'flowId: $flowId, '
        'poseId: $poseId, '
        'order: $order, '
        'transitionId: $transitionId, '
        'isSynced: $isSynced)';
  }

  @override
  bool operator ==(covariant FlowPoseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.flowId == flowId &&
        other.poseId == poseId &&
        other.order == order &&
        other.transitionId == transitionId &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    flowId.hashCode ^
    poseId.hashCode ^
    order.hashCode ^
    transitionId.hashCode ^
    isSynced.hashCode;
  }
}