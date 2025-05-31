import 'dart:convert';

class TagModel {
  final String id;
  final String name;
  final String userId;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;

  const TagModel({
    required this.id,
    required this.name,
    required this.userId,
    this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      color: map['color'],
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt']),
      updatedAt: DateTime.parse(map['updated_at'] ?? map['updatedAt']),
      isSynced: map['is_synced'] ?? map['isSynced'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user_id': userId,
      'color': color,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory TagModel.fromJson(String source) =>
      TagModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
