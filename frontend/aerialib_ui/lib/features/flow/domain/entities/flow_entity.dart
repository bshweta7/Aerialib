import 'package:frontend/features/flow/domain/entities/flow_pose_entity.dart';

class FlowEntity {
  final String id;
  final String name;
  final String thumbnailImageId;
  final String thumbnailImagePath;
  final String apparatus;
  final double level;

  final List<FlowPoseEntity> poses; // Ordered list of PoseEntity
  final String? description;
  final String? teachingCues;
  final String? safetyCues;
  final String? progressions;

  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int isSynced;

  const FlowEntity({
    required this.id,
    required this.name,
    required this.thumbnailImageId,
    required this.thumbnailImagePath,
    required this.apparatus,
    required this.level,
    required this.poses,
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

  FlowEntity copyWith({
    String? id,
    String? name,
    String? thumbnailImageId,
    String? thumbnailImagePath,
    String? apparatus,
    double? level,
    List<FlowPoseEntity>? poses,
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
    return FlowEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnailImageId: thumbnailImageId ?? this.thumbnailImageId,
      thumbnailImagePath: thumbnailImagePath ?? this.thumbnailImagePath,
      apparatus: apparatus ?? this.apparatus,
      level: level ?? this.level,
      poses: poses ?? this.poses,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FlowEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              thumbnailImageId == other.thumbnailImageId &&
              thumbnailImagePath == other.thumbnailImagePath &&
              apparatus == other.apparatus &&
              level == other.level &&
              poses == other.poses &&
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
      thumbnailImageId.hashCode ^
      thumbnailImagePath.hashCode ^
      apparatus.hashCode ^
      level.hashCode ^
      poses.hashCode ^
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
