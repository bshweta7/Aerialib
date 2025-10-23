// lib/domain/entities/student_entity.dart

class StudentEntity {
  final String id;
  final String name;
  final int isSynced;

  const StudentEntity({
    required this.id,
    required this.name,
    required this.isSynced,
  });

  StudentEntity copyWith({
    String? id,
    String? name,
    int? isSynced,
  }) {
    return StudentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StudentEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      isSynced.hashCode;
}
