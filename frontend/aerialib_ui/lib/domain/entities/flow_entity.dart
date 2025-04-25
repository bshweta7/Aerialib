import 'package:frontend/domain/entities/flow_pose_entity.dart';

class FlowEntity {
  final String id;
  final String name;
  final List<FlowPoseEntity> poses; // Ordered list of PoseEntity
  final String? description;
  final String? apparatus;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;

  // TODO add level or let users group flows (like hoopla group, level, etc)

  const FlowEntity({
    required this.id,
    required this.name,
    required this.poses,
    this.description,
    this.apparatus,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  FlowEntity copyWith({
    String? id,
    String? name,
    List<FlowPoseEntity>? poses,
    String? description,
    String? apparatus,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return FlowEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      poses: poses ?? this.poses,
      description: description ?? this.description,
      apparatus: apparatus ?? this.apparatus,
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
              poses == other.poses &&
              description == other.description &&
              apparatus == other.apparatus &&
              createdBy == other.createdBy &&
              updatedBy == other.updatedBy &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      poses.hashCode ^
      description.hashCode ^
      apparatus.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
}

