import 'dart:convert';

class FlowModel {
  final String id;
  final String name;
  final String? description;
  final String? apparatus;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;

  const FlowModel({
    required this.id,
    required this.name,
    this.description,
    this.apparatus,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory FlowModel.fromMap(Map<String, dynamic> map) {
    return FlowModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      apparatus: map['apparatus'],
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 0, // Default to synced if not present
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'apparatus': apparatus,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory FlowModel.fromJson(String source) =>
      FlowModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}