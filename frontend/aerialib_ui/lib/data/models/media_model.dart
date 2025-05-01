import 'dart:convert';

class MediaModel {
  final String id;
  final String path; // maps to 'media_path'
  final String type; // maps to 'media_type'
  final int? fileSize;
  final String? primaryMedia;
  final String? name;
  final String? description;
  final String? apparatus;
  final String uploadedBy;
  final DateTime uploadedAt;
  final int isSynced;

  MediaModel({
    required this.id,
    required this.path,
    required this.type,
    this.fileSize,
    this.primaryMedia,
    this.name,
    this.description,
    this.apparatus,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.isSynced,
  });

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      id: map['id'] ?? '',
      path: map['media_path'] ?? '',
      type: map['type'] ?? '',
      fileSize: map['file_size'],
      primaryMedia: map['primary_media'],
      name: map['name'],
      description: map['description'],
      apparatus: map['apparatus'],
      uploadedBy: map['uploaded_by'] ?? '',
      uploadedAt: DateTime.parse(map['uploaded_at']),
      isSynced: map['is_synced'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'media_path': path,
      'type': type,
      'file_size': fileSize,
      'primary_media': primaryMedia,
      'name': name,
      'description': description,
      'apparatus': apparatus,
      'uploaded_by': uploadedBy,
      'uploaded_at': uploadedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory MediaModel.fromJson(String source) =>
      MediaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

}
