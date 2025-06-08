import 'dart:convert';

class MediaModel {
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

  const MediaModel({
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

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      id: map['id'] ?? '',
      mediaPath: map['media_path'] ?? map['mediaPath'] ?? '',
      mediaType: map['media_type'] ?? map['mediaType'] ?? '',
      fileSize: map['file_size'] ?? map['fileSize'],
      durationSeconds: map['duration_seconds'] ?? map['durationSeconds'],
      name: map['name'],
      description: map['description'],
      apparatus: map['apparatus'],
      origin: map['origin'],
      takenTime: map['taken_time'] != null
          ? DateTime.tryParse(map['taken_time'])
          : null,
      takenLocation: map['taken_location'],
      createdBy: map['created_by'] ?? map['createdBy'] ?? '',
      updatedBy: map['updated_by'] ?? map['updatedBy'],
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt']),
      updatedAt: DateTime.parse(map['updated_at'] ?? map['updatedAt']),
      isSynced: map['is_synced'] ?? map['isSynced'] ?? 1,
    );
  }

  Map<String, dynamic> toMapLocal() {
    return {
      'id': id,
      'media_path': mediaPath,
      'media_type': mediaType,
      'file_size': fileSize,
      'duration_seconds': durationSeconds,
      'name': name,
      'description': description,
      'apparatus': apparatus,
      'origin': origin,
      'taken_time': takenTime?.toIso8601String(),
      'taken_location': takenLocation,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  Map<String, dynamic> toMapRemote() {
    return {
      'id': id,
      'mediaPath': mediaPath,
      'mediaType': mediaType,
      'fileSize': fileSize,
      'durationSeconds': durationSeconds,
      'name': name,
      'description': description,
      'apparatus': apparatus,
      'origin': origin,
      'takenTime': takenTime?.toIso8601String(),
      'takenLocation': takenLocation,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MediaModel.fromJson(String source) =>
      MediaModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMapLocal());

  MediaModel copyWith({
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
    return MediaModel(
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
}