import 'dart:convert';
import 'package:frontend/core/constants/constants.dart';

class PoseModel {
  final String id;
  final String name;
  final String? description;
  final String? cues;
  final String apparatus;
  final int level;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt; // TODO - this should be nullable if never updated
  final int isSynced;
  final String primaryImageId;
  final String primaryImageUrl;

  const PoseModel({
    required this.id,
    required this.name,
    this.description,
    this.cues,
    required this.apparatus,
    required this.level,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    required this.primaryImageId,
    required this.primaryImageUrl,
  });

  factory PoseModel.fromMap(Map<String, dynamic> map) {
    return PoseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      cues: map['cues'],
      apparatus: map['apparatus'] ?? '',
      level: map['level'] ?? -1,
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 1,
      primaryImageId: map['primary_image_id'] ?? Constants.missingImageId,
      primaryImageUrl: map['primary_image_url'] ?? Constants.missingImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cues': cues,
      'apparatus': apparatus,
      'level': level,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
      'primary_image_id': primaryImageId,
      'primary_image_url': primaryImageUrl,
    };
  }

  factory PoseModel.fromJson(String source) =>
      PoseModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

}
