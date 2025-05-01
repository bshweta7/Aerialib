class MediaEntity {
  final String id;
  final String path;
  final String type;
  final int? fileSize;
  final String? primaryMedia;
  final String? name;
  final String? description;
  final String? apparatus;
  final String uploadedBy;
  final DateTime uploadedAt;
  final int isSynced;

  // TODO: Add fields like location later

  MediaEntity({
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

  MediaEntity copyWith({
    String? id,
    String? path,
    String? type,
    int? fileSize,
    String? primaryMedia,
    String? name,
    String? description,
    String? apparatus,
    String? uploadedBy,
    DateTime? uploadedAt,
    int? isSynced,
  }) {
    return MediaEntity(
      id: id ?? this.id,
      path: path ?? this.path,
      type: type ?? this.type,
      fileSize: fileSize ?? this.fileSize,
      primaryMedia: primaryMedia ?? this.primaryMedia,
      name: name ?? this.name,
      description: description ?? this.description,
      apparatus: apparatus ?? this.apparatus,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  String toString() {
    return 'MediaEntity('
        'id: $id, '
        'path: $path, '
        'type: $type, '
        'fileSize: $fileSize, '
        'primaryMedia: $primaryMedia, '
        'name: $name, '
        'description: $description, '
        'apparatus: $apparatus, '
        'uploadedBy: $uploadedBy, '
        'uploadedAt: $uploadedAt, '
        'isSynced: $isSynced'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MediaEntity &&
        other.id == id &&
        other.path == path &&
        other.type == type &&
        other.fileSize == fileSize &&
        other.primaryMedia == primaryMedia &&
        other.name == name &&
        other.description == description &&
        other.apparatus == apparatus &&
        other.uploadedBy == uploadedBy &&
        other.uploadedAt == uploadedAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      path.hashCode ^
      type.hashCode ^
      fileSize.hashCode ^
      primaryMedia.hashCode ^
      name.hashCode ^
      description.hashCode ^
      apparatus.hashCode ^
      uploadedBy.hashCode ^
      uploadedAt.hashCode ^
      isSynced.hashCode;
}
