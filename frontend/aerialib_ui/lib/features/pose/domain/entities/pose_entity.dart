// lib/domain/entities/pose_entity.dart

import 'package:uuid/uuid.dart';

class PoseEntity {
  final String id;
  final String slug;
  final String displayName;
  final String? altName;
  final String baseName;
  final String? prefix;
  final String? suffix;
  final String? handPosition;
  final String? legPosition;
  final String? positionInBar;
  final String apparatus;
  final int? level;
  final String? poseType;
  final String? description;
  final String? teachingCues;
  final String? safetyCues;
  final String? progressions;
  final String? modifications;
  final String? commonErrors;
  final String primaryMediaId;
  final String primaryMediaPath;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;

  factory PoseEntity.withGeneratedSlug({
    String? id,
    required String displayName,
    required String baseName,
    String? prefix,
    String? suffix,
    String? handPosition,
    String? legPosition,
    String? positionInBar,
    required String apparatus,
    int? level,
    String? poseType,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    String? modifications,
    String? commonErrors,
    required String primaryMediaId,
    required String primaryMediaPath,
    required String createdBy,
    String? updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    int isSynced = 0,
  }) {
    final slugParts = [
      prefix,
      baseName,
      suffix,
      handPosition,
      legPosition,
      positionInBar,
    ].where((part) => part != null && part.trim().isNotEmpty)
        .map((part) => part!.trim().toLowerCase());

    final generatedSlug = slugParts.join('-');

    return PoseEntity(
      id: id ?? const Uuid().v6(),
      slug: generatedSlug,
      displayName: displayName,
      altName: null,
      baseName: baseName,
      prefix: prefix,
      suffix: suffix,
      handPosition: handPosition,
      legPosition: legPosition,
      positionInBar: positionInBar,
      apparatus: apparatus,
      level: level,
      poseType: poseType,
      description: description,
      teachingCues: teachingCues,
      safetyCues: safetyCues,
      progressions: progressions,
      modifications: modifications,
      commonErrors: commonErrors,
      primaryMediaId: primaryMediaId,
      primaryMediaPath: primaryMediaPath,
      createdBy: createdBy,
      updatedBy: updatedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  const PoseEntity({
    required this.id,
    required this.slug,
    required this.displayName,
    this.altName,
    required this.baseName,
    this.prefix,
    this.suffix,
    this.handPosition,
    this.legPosition,
    this.positionInBar,
    required this.apparatus,
    this.level,
    this.poseType,
    this.description,
    this.teachingCues,
    this.safetyCues,
    this.progressions,
    this.modifications,
    this.commonErrors,
    required this.primaryMediaId,
    required this.primaryMediaPath,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  PoseEntity copyWith({
    String? id,
    String? slug,
    String? displayName,
    String? altName,
    String? baseName,
    String? prefix,
    String? suffix,
    String? handPosition,
    String? legPosition,
    String? positionInBar,
    String? apparatus,
    int? level,
    String? poseType,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    String? modifications,
    String? commonErrors,
    String? primaryMediaId,
    String? primaryMediaPath,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return PoseEntity(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      altName: altName ?? this.altName,
      baseName: baseName ?? this.baseName,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      handPosition: handPosition ?? this.handPosition,
      legPosition: legPosition ?? this.legPosition,
      positionInBar: positionInBar ?? this.positionInBar,
      apparatus: apparatus ?? this.apparatus,
      level: level ?? this.level,
      poseType: poseType ?? this.poseType,
      description: description ?? this.description,
      teachingCues: teachingCues ?? this.teachingCues,
      safetyCues: safetyCues ?? this.safetyCues,
      progressions: progressions ?? this.progressions,
      modifications: modifications ?? this.modifications,
      commonErrors: commonErrors ?? this.commonErrors,
      primaryMediaId: primaryMediaId ?? this.primaryMediaId,
      primaryMediaPath: primaryMediaPath ?? this.primaryMediaPath,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,

      'apparatus': apparatus,
      'level': level,
      'description': description,
      'primaryMediaId': primaryMediaId, // TODO remove & update
      'primaryMediaPath': primaryMediaPath,
      'createdBy': createdBy,
      'updatedBy': updatedBy,

      // TODO switch to DateTime instead of ISO strings
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PoseEntity.fromMap(Map<String, dynamic> map) {
    final displayName = (map['displayName'] as String?) ?? '';

    final baseName = displayName;
    final slug = displayName;

    return PoseEntity(
      id: (map['id'] as String?) ?? '',
      slug: slug,
      displayName: displayName,
      altName: map['altName'] as String?, // will be null with current toMap

      baseName: baseName,
      prefix: map['prefix'] as String?,
      suffix: map['suffix'] as String?,
      handPosition: map['handPosition'] as String?,
      legPosition: map['legPosition'] as String?,
      positionInBar: map['positionInBar'] as String?,

      apparatus: (map['apparatus'] as String?) ?? '',
      level: map['level'] is int ? map['level'] as int? : null,
      poseType: map['poseType'] as String?,

      description: map['description'] as String?,
      teachingCues: map['teachingCues'] as String?,
      safetyCues: map['safetyCues'] as String?,
      progressions: map['progressions'] as String?,
      modifications: map['modifications'] as String?,
      commonErrors: map['commonErrors'] as String?,

      primaryMediaId: (map['primaryMediaId'] as String?) ?? '',
      primaryMediaPath: (map['primaryMediaPath'] as String?) ?? '',

      createdBy: (map['createdBy'] as String?) ?? '',
      updatedBy: map['updatedBy'] as String?,

      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : DateTime.now(),

      isSynced: (map['isSynced'] as int?) ?? 1,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PoseEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              slug == other.slug &&
              displayName == other.displayName &&
              altName == other.altName &&
              baseName == other.baseName &&
              prefix == other.prefix &&
              suffix == other.suffix &&
              handPosition == other.handPosition &&
              legPosition == other.legPosition &&
              positionInBar == other.positionInBar &&
              apparatus == other.apparatus &&
              level == other.level &&
              poseType == other.poseType &&
              description == other.description &&
              teachingCues == other.teachingCues &&
              safetyCues == other.safetyCues &&
              progressions == other.progressions &&
              modifications == other.modifications &&
              commonErrors == other.commonErrors &&
              primaryMediaId == other.primaryMediaId &&
              primaryMediaPath == other.primaryMediaPath &&
              createdBy == other.createdBy &&
              updatedBy == other.updatedBy &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      slug.hashCode ^
      displayName.hashCode ^
      altName.hashCode ^
      baseName.hashCode ^
      prefix.hashCode ^
      suffix.hashCode ^
      handPosition.hashCode ^
      legPosition.hashCode ^
      positionInBar.hashCode ^
      apparatus.hashCode ^
      level.hashCode ^
      poseType.hashCode ^
      description.hashCode ^
      teachingCues.hashCode ^
      safetyCues.hashCode ^
      progressions.hashCode ^
      modifications.hashCode ^
      commonErrors.hashCode ^
      primaryMediaId.hashCode ^
      primaryMediaPath.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
}
