import 'dart:convert';
import 'package:frontend/core/constants/constants.dart';

class PoseModel {
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
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;

  const PoseModel({
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
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory PoseModel.fromMap(Map<String, dynamic> map) {
    return PoseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      primaryMediaId: map['primary_media_id'] ?? map['primaryMediaId'] ?? Constants.missingImageId,
      primaryMediaPath: map['primary_media_path'] ?? map['primaryMediaPath'] ?? Constants.missingImagePath,
      apparatus: map['apparatus'] ?? '',
      level: (map['level'] is int ? (map['level'] as int).toDouble() : map['level']) ?? -1.0, // Handle potential int or double

      description: map['description'],
      teachingCues: map['teaching_cues'] ?? map['teachingCues'],
      safetyCues: map['safety_cues'] ?? map['safetyCues'],
      progressions: map['progressions'],

      createdBy: map['created_by'] ?? map['createdBy'] ?? '',
      updatedBy: map['updated_by'] ?? map['updatedBy'],
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt']),
      updatedAt: DateTime.parse(map['updated_at'] ?? map['updatedAt']),

      isSynced: map['is_synced'] ?? map['isSynced'] ?? 1, // TODO verify if this is ok
    );
  }

  Map<String, dynamic> toMap() {
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
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory PoseModel.fromJson(String source) =>
      PoseModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  PoseModel copyWith({
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
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return PoseModel(
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
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }


}
