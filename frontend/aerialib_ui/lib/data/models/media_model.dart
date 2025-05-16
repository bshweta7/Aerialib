import 'dart:convert';

import 'package:flutter/cupertino.dart';

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

  // TODO - switch to snake_case (to match pose model). needs backend changes
  factory MediaModel.fromMap(Map<String, dynamic> map) {
    try {
      return MediaModel(
        id: map['id'] ?? '',
        path: map['media_path'] ?? map['mediaPath'] ?? '',
        type: map['media_type'] ?? map['mediaType'] ?? '',
        fileSize: map['file_size'] ?? map['fileSize'],
        primaryMedia: map['primary_media'] ?? map['primaryMedia'],
        name: map['name'],
        description: map['description'],
        apparatus: map['apparatus'],
        uploadedBy: map['uploaded_by'] ?? map['uploadedBy'] ?? '',
        uploadedAt: DateTime.parse(map['uploaded_at'] ?? map['uploadedAt']),
        isSynced: map['is_synced'] ?? map['isSynced'] ?? 1,
      );
    } catch (e, stack) {
      //debugprint("Failed to map media: $map");
      //debugprint("Error: $e\nStack: $stack");
      rethrow;
    }
  }




  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'media_path': path,
      'media_type': type,
      'file_size': fileSize,
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
