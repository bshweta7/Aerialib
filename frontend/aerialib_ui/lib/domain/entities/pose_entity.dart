// lib/domain/entities/pose_entity.dart

class PoseEntity {
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

  const PoseEntity({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PoseEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              primaryMediaId == other.primaryMediaId &&
              primaryMediaPath == other.primaryMediaPath &&
              apparatus == other.apparatus &&
              level == other.level &&
              description == other.description &&
              teachingCues == other.teachingCues &&
              safetyCues == other.safetyCues &&
              progressions == other.progressions &&
              createdBy == other.createdBy &&
              updatedBy == other.updatedBy &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      primaryMediaId.hashCode ^
      primaryMediaPath.hashCode ^
      apparatus.hashCode ^
      level.hashCode ^
      description.hashCode ^
      teachingCues.hashCode ^
      safetyCues.hashCode ^
      progressions.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
}