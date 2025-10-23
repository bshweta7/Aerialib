import 'dart:convert';
import 'package:frontend/core/constants/constants.dart';

class StudentModel {
  final String id;
  final String name;

  final int isSynced;

  const StudentModel({
    required this.id,
    required this.name,
    required this.isSynced,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isSynced: map['is_synced'] ?? map['isSynced'] ?? 1,
    );
  }

  // TODO is toMap supstudentd to just be camelcase?
  Map<String, dynamic> toMapLocal() {
    return {
      'id': id,
      'name': name,
      'is_synced': isSynced,
    };
  }

  Map<String, dynamic> toMapRemote() {
    return {
      'id': id,
      'name': name,
    };
  }


  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMapLocal());

  StudentModel copyWith({
    String? id,
    String? name,
    int? isSynced,
  }) {
    return StudentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
