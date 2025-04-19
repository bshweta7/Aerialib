// lib/data/models/pose_model.dart

import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/domain/entities/pose_entity.dart';

import '../../domain/entities/media_icon_entity.dart';

class PoseModel extends PoseEntity {
  const PoseModel({
    required super.id,
    required super.name,
    super.description,
    super.cues,
    required super.apparatus,
    required super.level,
    required super.createdBy,
    super.updatedBy,
    required super.createdAt,
    required super.updatedAt, // TODO - this should be nullable if never updated
    required super.isSynced,
    required super.primaryImageId,
    required super.primaryImageUrl,
  });

  /// Construct PoseModel from a Map (e.g., from SQLite or API JSON)
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

  /// Serialize PoseModel to a Map (for local DB or API)
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

  /// Deserialize PoseModel from a JSON string
  factory PoseModel.fromJson(String source) =>
      PoseModel.fromMap(json.decode(source));

  /// Serialize PoseModel to a JSON string
  String toJson() => json.encode(toMap());

  /// Convert this PoseModel into a domain-layer Pose entity
  PoseEntity toEntity() => this;

  /// Construct PoseModel from a domain-layer Pose entity
  factory PoseModel.fromEntity(PoseEntity pose) {
    return PoseModel(
      id: pose.id,
      name: pose.name,
      description: pose.description,
      cues: pose.cues,
      apparatus: pose.apparatus,
      level: pose.level,
      createdBy: pose.createdBy,
      updatedBy: pose.updatedBy,
      createdAt: pose.createdAt,
      updatedAt: pose.updatedAt,
      isSynced: pose.isSynced,
      primaryImageId: pose.primaryImageId,
      primaryImageUrl: pose.primaryImageUrl,
    );
  }
}
