import 'dart:convert';

import 'package:frontend/models/pose_model.dart';

class FlowModel {
  final String id;
  final String name;
  final String? description;
  final String? apparatus;
  final String primaryImageId;
  final String primaryImageUrl;
  // final List<PoseModel> posesInFlowList;

  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int isSynced;

  // TODO when implementing transitions - add another List and add empty transitions to maintain order
  FlowModel({
    required this.id,
    required this.name,
    this.description,
    required this.apparatus,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    required this.primaryImageId,
    required this.primaryImageUrl,
    // required this.posesInFlowList,
  });

  FlowModel copyWith({
    String? id,
    String? name,
    String? description,
    String? apparatus,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
    String? primaryImageId,
    String? primaryImageUrl,
    // List<PoseModel>? posesInFlowList,
  }) {
    return FlowModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      apparatus: apparatus ?? this.apparatus,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      primaryImageId: primaryImageId ?? this.primaryImageId,
      primaryImageUrl: primaryImageUrl ?? this.primaryImageUrl,
      // posesInFlowList: posesInFlowList ?? this.posesInFlowList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'apparatus': apparatus,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
      'primaryImageId': primaryImageId,
      'primaryImageUrl': primaryImageUrl,
      // 'posesInFlowList': posesInFlowList.map((pose) => pose.toMap()).toList(),
    };
  }

  factory FlowModel.fromMap(Map<String, dynamic> map) {
    return FlowModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      apparatus: map['apparatus'] ?? '',
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 1,
      primaryImageId: map['primary_image_id'] ?? '', // Replace with your default image ID
      primaryImageUrl: map['primary_image_url'] ?? '',

      // createdBy: map['createdBy'] ?? '',
      // updatedBy: map['updatedBy'] ?? '',
      // createdAt: DateTime.parse(map['createdAt']),
      // updatedAt: DateTime.parse(map['updatedAt']),
      // isSynced: map['isSynced'] ?? 1,
      // primaryImageId: map['primaryImageId'] ?? '', // Replace with your default image ID
      // primaryImageUrl: map['primaryImageUrl'] ?? '', // Replace with your default image URL

      // posesInFlowList: (map['posesInFlowList'] as List<dynamic>?)?.map((poseMap) => PoseModel.fromMap(poseMap as Map<String, dynamic>)).toList() ?? [], // Added posesInFlowList
    );
  }

  String toJson() => json.encode(toMap());

  factory FlowModel.fromJson(String source) =>
      FlowModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FlowModel('
        'id: $id, '
        'name: $name, '
        'description: $description, '
        'apparatus: $apparatus, '
        'createdBy: $createdBy, '
        'updatedBy: $updatedBy, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt, '
        'isSynced: $isSynced, '
        'primaryImageId: $primaryImageId, '
        'primaryImageUrl: $primaryImageUrl, ';
        // 'posesInFlowList: $posesInFlowList)'; // Added posesInFlowList
  }

  @override
  bool operator ==(covariant FlowModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.apparatus == apparatus &&
        other.createdBy == createdBy &&
        other.updatedBy == updatedBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isSynced == isSynced &&
        other.primaryImageId == primaryImageId &&
        other.primaryImageUrl == primaryImageUrl;
        // other.posesInFlowList == posesInFlowList; // Added posesInFlowList
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    description.hashCode ^
    apparatus.hashCode ^
    createdBy.hashCode ^
    updatedBy.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode ^
    isSynced.hashCode ^
    primaryImageId.hashCode ^
    primaryImageUrl.hashCode;
    // posesInFlowList.hashCode; // Added posesInFlowList
  }
}