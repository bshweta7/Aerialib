import 'dart:convert';
import 'package:frontend/core/constants/constants.dart';

class PoseModel {
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
  final String thumbnailMediaId;
  final String thumbnailMediaPath;

  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int isSynced;

  const PoseModel({
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
    required this.thumbnailMediaId,
    required this.thumbnailMediaPath,

    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory PoseModel.fromMap(Map<String, dynamic> map) {
    return PoseModel(
      id: map['id'] ?? '',

      slug: map['slug'] ?? '',
      displayName: map['display_name'] ?? map['displayName'] ?? '',
      altName: map['alt_name'],

      baseName: map['base_name'] ?? '',
      prefix: map['prefix'],
      suffix: map['suffix'],

      handPosition: map['hand_position'],
      legPosition: map['leg_position'],
      positionInBar: map['position_in_bar'],

      apparatus: map['apparatus'] ?? '',
      level: map['level'],
      poseType: map['pose_type'],

      description: map['description'],
      teachingCues: map['teaching_cues'] ?? map['teachingCues'],
      safetyCues: map['safety_cues'] ?? map['safetyCues'],
      progressions: map['progressions'],
      modifications: map['modifications'],
      commonErrors: map['common_errors'],

      primaryMediaId: map['primary_media_id'] ?? map['primaryMediaId'] ?? Constants.missingImageId,
      primaryMediaPath: map['primary_media_path'] ?? map['primaryMediaPath'] ?? Constants.missingImagePath,
      thumbnailMediaId: map['thumbnail_media_id'] ?? map['thumbnailMediaId'],
      thumbnailMediaPath: map['thumbnail_media_path'] ?? map['thumbnailMediaPath'],

      createdBy: map['created_by'] ?? map['createdBy'] ?? '',
      updatedBy: map['updated_by'] ?? map['updatedBy'],
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt']),
      updatedAt: DateTime.parse(map['updated_at'] ?? map['updatedAt']),
      isSynced: map['is_synced'] ?? map['isSynced'] ?? 1,
    );
  }

  // TODO is toMap supposed to just be camelcase?
  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'slug': slug,
      'display_name': displayName,
      'alt_name': altName,

      'base_name': baseName,
      'prefix': prefix,
      'suffix': suffix,

      'hand_position': handPosition,
      'leg_position': legPosition,
      'position_in_bar': positionInBar,

      'apparatus': apparatus,
      'level': level,
      'pose_type': poseType,

      'description': description,
      'teaching_cues': teachingCues,
      'safety_cues': safetyCues,
      'progressions': progressions,
      'modifications': modifications,
      'common_errors': commonErrors,

      'primary_media_id': primaryMediaId,
      'primary_media_path': primaryMediaPath,
      'thumbnail_media_id': thumbnailMediaId,
      'thumbnail_media_path': thumbnailMediaPath,

      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),

      'is_synced': isSynced,
    };
  }

  Map<String, dynamic> toMapRemote() {
    return {
      'id': id,

      'slug': slug,
      'displayName': displayName,
      'altName': altName,

      'baseName': baseName,
      'prefix': prefix,
      'suffix': suffix,

      'handPosition': handPosition,
      'legPosition': legPosition,
      'positionInBar': positionInBar,

      'apparatus': apparatus,
      'level': level,
      'poseType': poseType,

      'description': description,
      'teachingCues': teachingCues,
      'safetyCues': safetyCues,
      'progressions': progressions,
      'modifications': modifications,
      'commonErrors': commonErrors,

      'primaryMediaId': primaryMediaId,
      'thumbnailMediaId': thumbnailMediaId,

      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }


  factory PoseModel.fromJson(String source) =>
      PoseModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  PoseModel copyWith({
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
    String? thumbnailMediaId,
    String? thumbnailMediaPath,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return PoseModel(
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
      thumbnailMediaId: thumbnailMediaId ?? this.thumbnailMediaId,
      thumbnailMediaPath: thumbnailMediaPath ?? this.thumbnailMediaPath,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
