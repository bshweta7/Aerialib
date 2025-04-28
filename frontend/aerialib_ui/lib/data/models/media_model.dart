import 'dart:convert';

class MediaModel {
  final String mediaPath;
  final String name;
  final String description;
  final String apparatus;
  final String uploadedBy;
  final int isSynced;
  final DateTime? uploadedAt;
  final String id;
  // todo add other things like location and stuff

  MediaModel({
    required this.mediaPath,
    required this.name,
    required this.description,
    required this.apparatus,
    required this.uploadedBy,
    required this.isSynced,
    this.uploadedAt,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mediaURL': mediaPath,
      'name': name,
      'description': description,
      'apparatus': apparatus,
      'uploadedBy': uploadedBy,
      'isSynced': isSynced,
      'uploadedAt': uploadedAt?.toIso8601String(),
      'id': id,
    };
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      mediaPath: map['mediaURL'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      apparatus: map['apparatus'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      isSynced: map['isSynced'] ?? 1,
      uploadedAt: map['uploadedAt'] != null ? DateTime.parse(map['uploadedAt']) : null,
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaModel.fromJson(String source) =>
      MediaModel.fromMap(json.decode(source) as Map<String, dynamic>);

}