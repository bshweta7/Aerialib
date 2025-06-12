import 'dart:convert';
import '../../../../core/constants/constants.dart';

class FlowModel {
  final String id;
  final String name;
  final String primaryMediaId;
  final String primaryMediaPath;
  final String apparatus;
  final double level;

  final String? description;
  final String? teachingCues;
  final String? safetyCues;
  final String? progressions;
  final String? modifications;
  final String? commonErrors;

  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int isSynced;

  const FlowModel({
    required this.id,
    required this.name,
    required this.primaryMediaId,
    required this.primaryMediaPath,
    required this.apparatus,
    required this.level,
    this.description,
    this.teachingCues,
    this.safetyCues,
    this.progressions,
    this.modifications,
    this.commonErrors,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory FlowModel.fromMap(Map<String, dynamic> map) {
    return FlowModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      primaryMediaId: map['primary_media_id'] ?? map['primaryMediaId'] ?? Constants.missingImageId,
      primaryMediaPath: map['primary_media_path'] ?? map['primaryMediaPath'] ?? Constants.missingImagePath,
      apparatus: map['apparatus'] ?? '',
      level: (map['level'] is int ? (map['level'] as int).toDouble() : map['level']) ?? -1.0,

      description: map['description'],
      teachingCues: map['teaching_cues'] ?? map['teachingCues'],
      safetyCues: map['safety_cues'] ?? map['safetyCues'],
      progressions: map['progressions'],
      modifications: map['modifications'],
      commonErrors: map['common_errors'] ?? map['commonErrors'],

      createdBy: map['created_by'] ?? map['createdBy'] ?? '',
      updatedBy: map['updated_by'] ?? map['updatedBy'],
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt']),
      updatedAt: DateTime.parse(map['updated_at'] ?? map['updatedAt']),

      isSynced: map['is_synced'] ?? map['isSynced'] ?? 1,
    );
  }

  Map<String, dynamic> toMapLocal() {
    return {
      'id': id,
      'name': name,
      'primary_media_id': primaryMediaId,
      'primary_media_path': primaryMediaPath,
      'apparatus': apparatus,
      'level': level,
      'description': description,
      'teaching_cues': teachingCues,
      'safety_cues': safetyCues,
      'progressions': progressions,
      'modifications': modifications,
      'common_errors': commonErrors,
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
      'name': name,
      'primaryMediaId': primaryMediaId,
      'primaryMediaPath': primaryMediaPath,
      'apparatus': apparatus,
      'level': level,
      'description': description,
      'teachingCues': teachingCues,
      'safetyCues': safetyCues,
      'progressions': progressions,
      'modifications': modifications,
      'commonErrors': commonErrors,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory FlowModel.fromJson(String source) =>
      FlowModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMapLocal());

  FlowModel copyWith({
    String? id,
    String? name,
    String? primaryMediaId,
    String? primaryMediaPath,
    String? apparatus,
    double? level,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    String? modifications,
    String? commonErrors,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return FlowModel(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryMediaId: primaryMediaId ?? this.primaryMediaId,
      primaryMediaPath: primaryMediaPath ?? this.primaryMediaPath,
      apparatus: apparatus ?? this.apparatus,
      level: level ?? this.level,
      description: description ?? this.description,
      teachingCues: teachingCues ?? this.teachingCues,
      safetyCues: safetyCues ?? this.safetyCues,
      progressions: progressions ?? this.progressions,
      modifications: modifications ?? this.modifications,
      commonErrors: commonErrors ?? this.commonErrors,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
