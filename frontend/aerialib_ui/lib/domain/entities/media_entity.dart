class MediaEntity {
  final String mediaPath;
  final String name;
  final String description;
  final String apparatus;
  final String uploadedBy;
  final int isSynced;
  final DateTime? uploadedAt;
  final String id;
  // todo add other things like location and stuff

  const MediaEntity({
    required this.mediaPath,
    required this.name,
    required this.description,
    required this.apparatus,
    required this.uploadedBy,
    required this.isSynced,
    this.uploadedAt,
    required this.id,
  });

  MediaEntity copyWith({
    String? mediaPath,
    String? name,
    String? description,
    String? apparatus,
    String? uploadedBy,
    int? isSynced,
    DateTime? uploadedAt,
    String? id,
  }) {
    return MediaEntity(
      mediaPath: mediaPath ?? this.mediaPath,
      name: name ?? this.name,
      description: description ?? this.description,
      apparatus: apparatus ?? this.apparatus,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      isSynced: isSynced ?? this.isSynced,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return 'MediaModel('
        'mediaURL: $mediaPath, '
        'name: $name, '
        'description: $description, '
        'apparatus: $apparatus, '
        'uploadedBy: $uploadedBy, '
        'isSynced: $isSynced, '
        'uploadedAt: $uploadedAt, '
        'id: $id)';
  }

  @override
  bool operator ==(covariant MediaEntity other) {
    if (identical(this, other)) return true;

    return other.mediaPath == mediaPath &&
        other.name == name &&
        other.description == description &&
        other.apparatus == apparatus &&
        other.uploadedBy == uploadedBy &&
        other.isSynced == isSynced &&
        other.uploadedAt == uploadedAt &&
        other.id == id;
  }

  @override
  int get hashCode =>
    mediaPath.hashCode ^
    name.hashCode ^
    description.hashCode ^
    apparatus.hashCode ^
    uploadedBy.hashCode ^
    isSynced.hashCode ^
    uploadedAt.hashCode ^
    id.hashCode;
}