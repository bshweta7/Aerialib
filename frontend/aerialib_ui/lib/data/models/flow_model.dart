import 'dart:convert';

class FlowModel {
  final String id;
  final String name;
  final String thumbnailImageId;
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
      thumbnailImageId: map['thumbnail_image_id'] ?? '',
      apparatus: map['apparatus'] ?? '',
      level: (map['level'] as num).toDouble(),

      description: map['description'],
      teachingCues: map['teaching_cues'],
      safetyCues: map['safety_cues'],
      progressions: map['progressions'],

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
      'name': name,
      'thumbnail_image_id': thumbnailImageId,
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
