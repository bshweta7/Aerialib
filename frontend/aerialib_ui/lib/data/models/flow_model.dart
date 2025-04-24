import 'dart:convert';

class FlowModel {
  final String id;
  final String name;
  final String? description;
  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced; // Assuming you might want to track sync status

  const FlowModel({
    required this.id,
    required this.name,
    this.description,
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
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      isSynced: map['is_synced'] ?? 1, // Default to synced if not present
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
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