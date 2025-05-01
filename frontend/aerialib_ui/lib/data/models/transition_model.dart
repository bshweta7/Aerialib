import 'dart:convert';

class TransitionModel {
  final String id;

  final String fromPoseId;
  final String toPoseId;
  final double level;

  final String? name;
  final String? description;
  final String? teachingCues;
  final String? safetyCues;
  final String? progressions;

  final String? transitionType;
  final String? startingGrip;
  final String? endingGrip;

  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int isSynced;

  const TransitionModel({
    required this.id,
    required this.fromPoseId,
    required this.toPoseId,
    required this.level,
    this.name,
    this.description,
    this.teachingCues,
    this.safetyCues,
    this.progressions,
    this.transitionType,
    this.startingGrip,
    this.endingGrip,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory TransitionModel.fromMap(Map<String, dynamic> map) {
    return TransitionModel(
      id: map['id'] ?? '',
      fromPoseId: map['from_pose_id'] ?? '',
      toPoseId: map['to_pose_id'] ?? '',
      level: (map['level'] as num).toDouble(),
      name: map['name'],
      description: map['description'],
      teachingCues: map['teaching_cues'],
      safetyCues: map['safety_cues'],
      progressions: map['progressions'],
      transitionType: map['transition_type'],
      startingGrip: map['starting_grip'],
      endingGrip: map['ending_grip'],
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from_pose_id': fromPoseId,
      'to_pose_id': toPoseId,
      'level': level,
      'name': name,
      'description': description,
      'teaching_cues': teachingCues,
      'safety_cues': safetyCues,
      'progressions': progressions,
      'transition_type': transitionType,
      'starting_grip': startingGrip,
      'ending_grip': endingGrip,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory TransitionModel.fromJson(String source) =>
      TransitionModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
