import 'dart:convert';
import 'package:frontend/core/constants/constants.dart';

class TransitionModel {
  final String id;

  final String fromPoseId;
  final String toPoseId;

  final String? name;
  final String apparatus;
  final int? level;
  final String? transitionType;

  final String? description;
  final String? teachingCues;
  final String? safetyCues;
  final String? progressions;
  final String? modifications;
  final String? commonErrors;

  final String? primaryMediaId;
  final String? primaryMediaPath;

  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int isSynced;

  const TransitionModel({
    required this.id,
    required this.fromPoseId,
    required this.toPoseId,
    this.name,
    required this.apparatus,
    this.level,
    this.transitionType,
    this.description,
    this.teachingCues,
    this.safetyCues,
    this.progressions,
    this.modifications,
    this.commonErrors,
    this.primaryMediaId,
    this.primaryMediaPath,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory TransitionModel.fromMap(Map<String, dynamic> map) {
    return TransitionModel(
      id: map['id'] ?? '',
      fromPoseId: map['from_pose_id'],
      toPoseId: map['to_pose_id'],
      name: map['name'],
      apparatus: map['apparatus'],
      level: map['level'],
      transitionType: map['transition_type'],
      description: map['description'],
      teachingCues: map['teaching_cues'],
      safetyCues: map['safety_cues'],
      progressions: map['progressions'],
      modifications: map['modifications'],
      commonErrors: map['common_errors'],
      primaryMediaId: map['primary_media_id'],
      primaryMediaPath: map['primary_media_path'],
      createdBy: map['created_by'],
      updatedBy: map['updated_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 1,
    );
  }

  Map<String, dynamic> toMapLocal() {
    return {
      'id': id,
      'from_pose_id': fromPoseId,
      'to_pose_id': toPoseId,
      'name': name,
      'apparatus': apparatus,
      'level': level,
      'transition_type': transitionType,
      'description': description,
      'teaching_cues': teachingCues,
      'safety_cues': safetyCues,
      'progressions': progressions,
      'modifications': modifications,
      'common_errors': commonErrors,
      'primary_media_id': primaryMediaId,
      'primary_media_path': primaryMediaPath,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  Map<String, dynamic> toMapRemote() {
    return {
      'id': id,
      'fromPoseId': fromPoseId,
      'toPoseId': toPoseId,
      'name': name,
      'apparatus': apparatus,
      'level': level,
      'transitionType': transitionType,
      'description': description,
      'teachingCues': teachingCues,
      'safetyCues': safetyCues,
      'progressions': progressions,
      'modifications': modifications,
      'commonErrors': commonErrors,
      'primaryMediaId': primaryMediaId,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TransitionModel.fromJson(String source) =>
      TransitionModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMapLocal());

  TransitionModel copyWith({
    String? id,
    String? fromPoseId,
    String? toPoseId,
    String? name,
    String? apparatus,
    int? level,
    String? transitionType,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    String? modifications,
    String? commonErrors,
    String? primaryMediaId,
    String? primaryMediaPath,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return TransitionModel(
      id: id ?? this.id,
      fromPoseId: fromPoseId ?? this.fromPoseId,
      toPoseId: toPoseId ?? this.toPoseId,
      name: name ?? this.name,
      apparatus: apparatus ?? this.apparatus,
      level: level ?? this.level,
      transitionType: transitionType ?? this.transitionType,
      description: description ?? this.description,
      teachingCues: teachingCues ?? this.teachingCues,
      safetyCues: safetyCues ?? this.safetyCues,
      progressions: progressions ?? this.progressions,
      modifications: modifications ?? this.modifications,
      commonErrors: commonErrors ?? this.commonErrors,
      primaryMediaId: primaryMediaId ?? this.primaryMediaId,
      primaryMediaPath: primaryMediaPath ?? this.primaryMediaPath,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
