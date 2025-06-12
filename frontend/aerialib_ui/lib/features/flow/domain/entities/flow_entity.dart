class FlowEntity {
  final String id;

  final String name;
  final String apparatus;
  final double level;

  final String? description;
  final String? teachingCues;
  final String? safetyCues;
  final String? progressions;
  final String? modifications;
  final String? commonErrors;

  final String? primaryMediaId;
  final String? primaryMediaPath;

  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int isSynced;

  const FlowEntity({
    required this.id,
    required this.name,
    required this.apparatus,
    required this.level,
    this.description,
    this.teachingCues,
    this.safetyCues,
    this.progressions,
    this.modifications,
    this.commonErrors,
    this.primaryMediaId,
    this.primaryMediaPath,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  FlowEntity copyWith({
    String? id,
    String? name,
    String? apparatus,
    double? level,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    String? modifications,
    String? commonErrors,
    String? primaryMediaId,
    String? primaryMediaPath,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return FlowEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      apparatus: apparatus ?? this.apparatus,
      level: level ?? this.level,
      description: description ?? this.description,
      teachingCues: teachingCues ?? this.teachingCues,
      safetyCues: safetyCues ?? this.safetyCues,
      progressions: progressions ?? this.progressions,
      modifications: modifications ?? this.modifications,
      commonErrors: commonErrors ?? this.commonErrors,
      primaryMediaId: primaryMediaId ?? this.primaryMediaId,
      primaryMediaPath: primaryMediaPath ?? this.primaryMediaPath,
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
          other is FlowEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              apparatus == other.apparatus &&
              level == other.level &&
              description == other.description &&
              teachingCues == other.teachingCues &&
              safetyCues == other.safetyCues &&
              progressions == other.progressions &&
              modifications == other.modifications &&
              commonErrors == other.commonErrors &&
              primaryMediaId == other.primaryMediaId &&
              primaryMediaPath == other.primaryMediaPath &&
              createdBy == other.createdBy &&
              updatedBy == other.updatedBy &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      apparatus.hashCode ^
      level.hashCode ^
      description.hashCode ^
      teachingCues.hashCode ^
      safetyCues.hashCode ^
      progressions.hashCode ^
      modifications.hashCode ^
      commonErrors.hashCode ^
      primaryMediaId.hashCode ^
      primaryMediaPath.hashCode ^
      createdBy.hashCode ^
      updatedBy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;
}
