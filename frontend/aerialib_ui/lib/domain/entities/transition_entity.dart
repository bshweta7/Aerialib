class TransitionEntity {
  final String id;

  final String fromPoseId;
  final String toPoseId;
  final double level;

  final String? name;
  final String? description;
  final String? teachingCues;
  final String? safetyCues;
  final String? progressions;

  final String? transitionType;
  final String? startingGrip;
  final String? endingGrip;

  final String createdBy;
  final String? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int isSynced;

  const TransitionEntity({
    required this.id,
    required this.fromPoseId,
    required this.toPoseId,
    required this.level,
    this.name,
    this.description,
    this.teachingCues,
    this.safetyCues,
    this.progressions,
    this.transitionType,
    this.startingGrip,
    this.endingGrip,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  TransitionEntity copyWith({
    String? id,
    String? fromPoseId,
    String? toPoseId,
    double? level,
    String? name,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    String? transitionType,
    String? startingGrip,
    String? endingGrip,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return TransitionEntity(
      id: id ?? this.id,
      fromPoseId: fromPoseId ?? this.fromPoseId,
      toPoseId: toPoseId ?? this.toPoseId,
      level: level ?? this.level,
      name: name ?? this.name,
      description: description ?? this.description,
      teachingCues: teachingCues ?? this.teachingCues,
      safetyCues: safetyCues ?? this.safetyCues,
      progressions: progressions ?? this.progressions,
      transitionType: transitionType ?? this.transitionType,
      startingGrip: startingGrip ?? this.startingGrip,
      endingGrip: endingGrip ?? this.endingGrip,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
