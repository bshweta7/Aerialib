import 'dart:convert';

import '../../core/constants/constants.dart';

class FlowModel {
  final String id;
  final String name;
  final String thumbnailImageId;
  final String thumbnailImagePath;
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

  const FlowModel({
    required this.id,
    required this.name,
    required this.thumbnailImageId,
    required this.thumbnailImagePath,
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

  factory FlowModel.fromMap(Map<String, dynamic> map) {
    return FlowModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      thumbnailImageId: map['thumbnail_image_id'] ?? map['thumbnailImageId'] ?? Constants.missingImageId,
      thumbnailImagePath: map['thumbnail_image_path'] ?? map['thumbnailImagePath'] ?? Constants.missingImagePath,
      apparatus: map['apparatus'] ?? '',
      level: (map['level'] is int ? (map['level'] as int).toDouble() : map['level']) ?? -1.0,

      description: map['description'],
      teachingCues: map['teaching_cues'] ?? map['teachingCues'],
      safetyCues: map['safety_cues'] ?? map['safetyCues'],
      progressions: map['progressions'],

      createdBy: map['created_by'] ?? map['createdBy'] ?? '',
      updatedBy: map['updated_by'] ?? map['updatedBy'],
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt']),
      updatedAt: DateTime.parse(map['updated_at'] ?? map['updatedAt']),

      isSynced: map['is_synced'] ?? map['isSynced'] ?? 0,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail_image_id': thumbnailImageId,
      'thumbnail_image_path': thumbnailImagePath,
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

  factory FlowModel.fromJson(String source) =>
      FlowModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
