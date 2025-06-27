import 'dart:convert';
import '../../../../core/constants/constants.dart';

class AdminFlowModel {
  final String id; // TODO remove this - not needed to display...
  final String name;
  final String apparatus;
  final int numPoses;

  final String createdBy;
  // final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminFlowModel({
    required this.id,
    required this.name,
    required this.apparatus,
    required this.numPoses,
    required this.createdBy,
    // this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminFlowModel.fromMap(Map<String, dynamic> map) {
    return AdminFlowModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      apparatus: map['apparatus'] ?? '',
      numPoses: (map['num_poses'] is int ? (map['num_poses'] as int) : map['num_poses']) ?? -1,

      createdBy: map['created_by'] ?? map['createdBy'] ?? '',
      // updatedBy: map['updated_by'] ?? map['updatedBy'],
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt']),
      updatedAt: DateTime.parse(map['updated_at'] ?? map['updatedAt']),
    );
  }

  // Map<String, dynamic> toMapLocal() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'apparatus': apparatus,
  //     'apparatus': apparatus,
  //     'created_by': createdBy,
  //     // 'updated_by': updatedBy,
  //     // 'created_at': createdAt.toIso8601String(),
  //     // 'updated_at': updatedAt.toIso8601String(),
  //   };
  // }
  //
  // Map<String, dynamic> toMapRemote() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'primaryMediaId': primaryMediaId,
  //     'primaryMediaPath': primaryMediaPath,
  //     'apparatus': apparatus,
  //     'level': level,
  //     'description': description,
  //     'teachingCues': teachingCues,
  //     'safetyCues': safetyCues,
  //     'progressions': progressions,
  //     'modifications': modifications,
  //     'commonErrors': commonErrors,
  //     'createdBy': createdBy,
  //     'updatedBy': updatedBy,
  //     'createdAt': createdAt.toIso8601String(),
  //     'updatedAt': updatedAt.toIso8601String(),
  //   };
  // }

  factory AdminFlowModel.fromJson(String source) =>
      AdminFlowModel.fromMap(json.decode(source));

  // String toJson() => json.encode(toMapLocal());

  // AdminFlowModel copyWith({
  //   String? id,
  //   String? name,
  //   String? primaryMediaId,
  //   String? primaryMediaPath,
  //   String? apparatus,
  //   int? level,
  //   String? description,
  //   String? teachingCues,
  //   String? safetyCues,
  //   String? progressions,
  //   String? modifications,
  //   String? commonErrors,
  //   String? createdBy,
  //   String? updatedBy,
  //   DateTime? createdAt,
  //   DateTime? updatedAt,
  //   int? isSynced,
  // }) {
  //   return AdminFlowModel(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     primaryMediaId: primaryMediaId ?? this.primaryMediaId,
  //     primaryMediaPath: primaryMediaPath ?? this.primaryMediaPath,
  //     apparatus: apparatus ?? this.apparatus,
  //     level: level ?? this.level,
  //     description: description ?? this.description,
  //     teachingCues: teachingCues ?? this.teachingCues,
  //     safetyCues: safetyCues ?? this.safetyCues,
  //     progressions: progressions ?? this.progressions,
  //     modifications: modifications ?? this.modifications,
  //     commonErrors: commonErrors ?? this.commonErrors,
  //     createdBy: createdBy ?? this.createdBy,
  //     updatedBy: updatedBy ?? this.updatedBy,
  //     createdAt: createdAt ?? this.createdAt,
  //     updatedAt: updatedAt ?? this.updatedAt,
  //     isSynced: isSynced ?? this.isSynced,
  //   );
  // }
}
