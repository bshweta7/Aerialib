// lib/domain/entities/pose_entity.dart

class PoseEntity {
  final String id;
  final String name;
  final String? description;
  final String? cues;
  final String apparatus;
  final int level;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;
  final String primaryImageId;
  final String primaryImageUrl;

  const PoseEntity({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PoseEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              description == other.description &&
              cues == other.cues &&
              apparatus == other.apparatus &&
              level == other.level &&
              createdBy == other.createdBy &&
              updatedBy == other.updatedBy &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              isSynced == other.isSynced &&
              primaryImageId == other.primaryImageId &&
              primaryImageUrl == other.primaryImageUrl;

  @override
  int get hashCode =>
      id.hashCode ^
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
