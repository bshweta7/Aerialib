import 'dart:convert';

class TransitionModel {
  final String id;
  final String fromPoseId;
  final String toPoseId;
  final String? name;
  final String? description;
  final String? cues;
  final int? difficulty;
  final double? duration;
  final String? primaryVideoId;
  final int isSynced;

  TransitionModel({
    required this.id,
    required this.fromPoseId,
    required this.toPoseId,
    this.name,
    this.description,
    this.cues,
    this.difficulty,
    this.duration,
    this.primaryVideoId,
    required this.isSynced,
  });

  TransitionModel copyWith({
    String? id,
    String? fromPoseId,
    String? toPoseId,
    String? name,
    String? description,
    String? cues,
    int? difficulty,
    double? duration,
    String? primaryVideoId,
    int? isSynced,
  }) {
    return TransitionModel(
      id: id ?? this.id,
      fromPoseId: fromPoseId ?? this.fromPoseId,
      toPoseId: toPoseId ?? this.toPoseId,
      name: name ?? this.name,
      description: description ?? this.description,
      cues: cues ?? this.cues,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      primaryVideoId: primaryVideoId ?? this.primaryVideoId,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fromPoseId': fromPoseId,
      'toPoseId': toPoseId,
      'name': name,
      'description': description,
      'cues': cues,
      'difficulty': difficulty,
      'duration': duration,
      'primaryVideoId': primaryVideoId,
      'isSynced': isSynced,
    };
  }

  factory TransitionModel.fromMap(Map<String, dynamic> map) {
    return TransitionModel(
      id: map['id'] ?? '',
      fromPoseId: map['fromPoseId'] ?? '',
      toPoseId: map['toPoseId'] ?? '',
      name: map['name'],
      description: map['description'],
      cues: map['cues'],
      difficulty: map['difficulty'],
      duration: map['duration'],
      primaryVideoId: map['primaryVideoId'],
      isSynced: map['is_synced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransitionModel.fromJson(String source) =>
      TransitionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransitionModel('
        'id: $id, '
        'fromPoseId: $fromPoseId, '
        'toPoseId: $toPoseId, '
        'name: $name, '
        'description: $description, '
        'cues: $cues, '
        'difficulty: $difficulty, '
        'duration: $duration, '
        'primaryVideoId: $primaryVideoId)'
        'isSynced: $isSynced, ';
  }

  @override
  bool operator ==(covariant TransitionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fromPoseId == fromPoseId &&
        other.toPoseId == toPoseId &&
        other.name == name &&
        other.description == description &&
        other.cues == cues &&
        other.difficulty == difficulty &&
        other.duration == duration &&
        other.primaryVideoId == primaryVideoId &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    fromPoseId.hashCode ^
    toPoseId.hashCode ^
    name.hashCode ^
    description.hashCode ^
    cues.hashCode ^
    difficulty.hashCode ^
    duration.hashCode ^
    primaryVideoId.hashCode ^
    isSynced.hashCode;
  }
}