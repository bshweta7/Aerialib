import 'dart:convert';

class MediaModel {
  final String mediaURL;
  final String name;
  final String description;
  final String apparatus;
  final String uploadedBy;
  final int isSynced;
  final DateTime? uploadedAt;
  final String id;

  MediaModel({
    required this.mediaURL,
    required this.name,
    required this.description,
    required this.apparatus,
    required this.uploadedBy,
    required this.isSynced,
    this.uploadedAt,
    required this.id,
  });

  MediaModel copyWith({
    String? mediaURL,
    String? name,
    String? description,
    String? apparatus,
    String? uploadedBy,
    int? isSynced,
    DateTime? uploadedAt,
    String? id,
  }) {
    return MediaModel(
      mediaURL: mediaURL ?? this.mediaURL,
      name: name ?? this.name,
      description: description ?? this.description,
      apparatus: apparatus ?? this.apparatus,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      isSynced: isSynced ?? this.isSynced,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mediaURL': mediaURL,
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
      mediaURL: map['mediaURL'] ?? '',
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

  @override
  String toString() {
    return 'MediaModel('
        'mediaURL: $mediaURL, '
        'name: $name, '
        'description: $description, '
        'apparatus: $apparatus, '
        'uploadedBy: $uploadedBy, '
        'isSynced: $isSynced, '
        'uploadedAt: $uploadedAt, '
        'id: $id)';
  }

  @override
  bool operator ==(covariant MediaModel other) {
    if (identical(this, other)) return true;

    return other.mediaURL == mediaURL &&
        other.name == name &&
        other.description == description &&
        other.apparatus == apparatus &&
        other.uploadedBy == uploadedBy &&
        other.isSynced == isSynced &&
        other.uploadedAt == uploadedAt &&
        other.id == id;
  }

  @override
  int get hashCode {
    return mediaURL.hashCode ^
    name.hashCode ^
    description.hashCode ^
    apparatus.hashCode ^
    uploadedBy.hashCode ^
    isSynced.hashCode ^
    uploadedAt.hashCode ^
    id.hashCode;
  }
}