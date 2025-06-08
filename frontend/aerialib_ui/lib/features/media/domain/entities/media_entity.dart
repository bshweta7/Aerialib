import 'package:uuid/uuid.dart';

class MediaEntity {
  final String id;
  final String mediaPath;
  final String mediaType;
  final int? fileSize;
  final int? durationSeconds;

  final String? name;
  final String? description;
  final String? apparatus;
  final String? origin;

  final DateTime? takenTime;
  final String? takenLocation;

  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int isSynced;

  const MediaEntity({
    required this.id,
    required this.mediaPath,
    required this.mediaType,
    this.fileSize,
    this.durationSeconds,
    this.name,
    this.description,
    this.apparatus,
    this.origin,
    this.takenTime,
    this.takenLocation,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory MediaEntity.withGeneratedId({
    required String mediaPath,
    required String mediaType,
    int? fileSize,
    int? durationSeconds,
    String? name,
    String? description,
    String? apparatus,
    String? origin,
    DateTime? takenTime,
    String? takenLocation,
    required String createdBy,
    String? updatedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    int isSynced = 0,
  }) {
    return MediaEntity(
      id: const Uuid().v6(),
      mediaPath: mediaPath,
      mediaType: mediaType,
      fileSize: fileSize,
      durationSeconds: durationSeconds,
      name: name,
      description: description,
      apparatus: apparatus,
      origin: origin,
      takenTime: takenTime,
      takenLocation: takenLocation,
      createdBy: createdBy,
      updatedBy: updatedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  MediaEntity copyWith({
    String? id,
    String? mediaPath,
    String? mediaType,
    int? fileSize,
    int? durationSeconds,
    String? name,
    String? description,
    String? apparatus,
    String? origin,
    DateTime? takenTime,
    String? takenLocation,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return MediaEntity(
      id: id ?? this.id,
      mediaPath: mediaPath ?? this.mediaPath,
      mediaType: mediaType ?? this.mediaType,
      fileSize: fileSize ?? this.fileSize,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      name: name ?? this.name,
      description: description ?? this.description,
      apparatus: apparatus ?? this.apparatus,
      origin: origin ?? this.origin,
      takenTime: takenTime ?? this.takenTime,
      takenLocation: takenLocation ?? this.takenLocation,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MediaEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              mediaPath == other.mediaPath &&
              mediaType == other.mediaType &&
              fileSize == other.fileSize &&
              durationSeconds == other.durationSeconds &&
              name == other.name &&
              description == other.description &&
              apparatus == other.apparatus &&
              origin == other.origin &&
              takenTime == other.takenTime &&
              takenLocation == other.takenLocation &&
              createdBy == other.createdBy &&
              updatedBy == other.updatedBy &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      mediaPath.hashCode ^
      mediaType.hashCode ^
      fileSize.hashCode ^
      durationSeconds.hashCode ^
      name.hashCode ^
      description.hashCode ^
      apparatus.hashCode ^
      origin.hashCode ^
      takenTime.hashCode ^
      takenLocation.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
}
