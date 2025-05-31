class TagEntity {
  final String id;
  final String name;
  final String userId;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;

  const TagEntity({
    required this.id,
    required this.name,
    required this.userId,
    this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  TagEntity copyWith({
    String? id,
    String? name,
    String? userId,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return TagEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TagEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              userId == other.userId &&
              color == other.color &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      userId.hashCode ^
      color.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
}
