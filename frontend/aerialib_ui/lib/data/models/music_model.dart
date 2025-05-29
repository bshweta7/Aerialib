import 'dart:convert';

class MusicModel {
  final String id;
  final String userId;
  final String name;
  final String? artist;
  final String? mood;
  final String? link;
  final String? performanceNotes;
  final int? tempoBpm;
  final int? durationSec;
  final bool favorite;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;

  MusicModel({
    required this.id,
    required this.userId,
    required this.name,
    this.artist,
    this.mood,
    this.link,
    this.performanceNotes,
    this.tempoBpm,
    this.durationSec,
    required this.favorite,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory MusicModel.fromMap(Map<String, dynamic> map) {
    return MusicModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? map['userId'] ?? '',
      name: map['name'] ?? '',
      artist: map['artist'],
      mood: map['mood'],
      link: map['link'],
      performanceNotes: map['performance_notes'] ?? map['performanceNotes'],
      tempoBpm: map['tempo_bpm'] ?? map['tempoBpm'],
      durationSec: map['duration_sec'] ?? map['durationSec'],
      favorite: (map['favorite'] == 1 || map['favorite'] == true),
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt']),
      updatedAt: DateTime.parse(map['updated_at'] ?? map['updatedAt']),
      isSynced: map['is_synced'] ?? map['isSynced'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'artist': artist,
      'mood': mood,
      'link': link,
      'performance_notes': performanceNotes,
      'tempo_bpm': tempoBpm,
      'duration_sec': durationSec,
      'favorite': favorite ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  MusicModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? artist,
    String? mood,
    String? link,
    String? performanceNotes,
    int? tempoBpm,
    int? durationSec,
    bool? favorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return MusicModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      mood: mood ?? this.mood,
      link: link ?? this.link,
      performanceNotes: performanceNotes ?? this.performanceNotes,
      tempoBpm: tempoBpm ?? this.tempoBpm,
      durationSec: durationSec ?? this.durationSec,
      favorite: favorite ?? this.favorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  factory MusicModel.fromJson(String source) =>
      MusicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());
}
