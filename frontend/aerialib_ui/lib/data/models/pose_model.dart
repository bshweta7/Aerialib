import 'dart:convert';
import 'package:frontend/core/constants/constants.dart';

class PoseModel {
  final String id;
  final String name;
  final String primaryImageId;
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
    required this.primaryImageId,
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
      primaryImageId: map['primary_image_id'] ?? Constants.missingImageId,
      apparatus: map['apparatus'] ?? '',
      level: (map['level'] is int ? (map['level'] as int).toDouble() : map['level']) ?? -1.0, // Handle potential int or double
      description: map['description'],
      teachingCues: map['teaching_cues'],
      safetyCues: map['safety_cues'],
      progressions: map['progressions'],
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'primary_image_id': primaryImageId,
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
      // 'is_synced': isSynced,
    };
  }

  factory PoseModel.fromJson(String source) =>
      PoseModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
