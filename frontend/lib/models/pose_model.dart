import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';

class PoseModel {
  final String id;
  final String name;
  final String? description;
  final String? cues;
  final String apparatus;
  final int level;
  final String createdBy; // TODO why is this not UUID Type?
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;
  final String primaryImageId;
  final String primaryImageUrl;

  PoseModel({
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

  PoseModel copyWith({
    String? id,
    String? name,
    String? description,
    String? cues,
    String? apparatus,
    int? level,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
    String? primaryImageId,
    String? primaryImageUrl,
  }) {
    return PoseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cues: cues ?? this.cues,
      apparatus: apparatus ?? this.apparatus,
      level: level ?? this.level,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      primaryImageId: primaryImageId ?? this.primaryImageId,
      primaryImageUrl: primaryImageUrl ?? this.primaryImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'cues': cues,
      'apparatus': apparatus,
      'level': level,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
      'primaryImageId': primaryImageId,
      'primaryImageUrl': primaryImageUrl,
    };
  }

  factory PoseModel.fromMap(Map<String, dynamic> map) {
    return PoseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      cues: map['cues'],
      apparatus: map['apparatus'] ?? '',
      level: map['level'] ?? -1,
      createdBy: map['createdBy'] ?? '',
      updatedBy: map['updatedBy'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 1,
      primaryImageId: map['primary_image_id'] ?? Constants.missingImageId,
      primaryImageUrl: map['primary_image_url'] ?? Constants.missingImageUrl,
      // createdBy: map['createdBy'] ?? '',
      // updatedBy: map['updatedBy'] ?? '',
      // createdAt: DateTime.parse(map['createdAt']),
      // updatedAt: DateTime.parse(map['updatedAt']),
      // isSynced: map['isSynced'] ?? 1,
      // primaryImageId: map['primaryImageId'] ?? Constants.missingImageId,
      // primaryImageUrl: map['primaryImageUrl'] ?? Constants.missingImageUrl,
      // TODO update the mapping or local db so local and remote match
    );
  }

  String toJson() => json.encode(toMap());

  factory PoseModel.fromJson(String source) =>
      PoseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PoseModel('
        'id: $id, '
        'name: $name, '
        'description: $description, '
        'cues: $cues, '
        'apparatus: $apparatus, '
        'level: $level, '
        'createdBy: $createdBy, '
        'updatedBy: $updatedBy, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'isSynced: $isSynced, '
        'primaryImageId: $primaryImageId, '
        'primaryImageUrl: $primaryImageUrl)';
  }

  @override
  bool operator ==(covariant PoseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.cues == cues &&
        other.apparatus == apparatus &&
        other.level == level &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isSynced == isSynced &&
        other.primaryImageId == primaryImageId &&
        other.primaryImageUrl == primaryImageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    description.hashCode ^
    cues.hashCode ^
    apparatus.hashCode ^
    level.hashCode ^
    createdBy.hashCode ^
    updatedBy.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode ^
    isSynced.hashCode ^
    primaryImageId.hashCode ^
    primaryImageUrl.hashCode;
  }
}