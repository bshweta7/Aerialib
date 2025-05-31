// lib/domain/entities/music_entity.dart

class MusicEntity {
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

  const MusicEntity({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MusicEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              userId == other.userId &&
              name == other.name &&
              artist == other.artist &&
              mood == other.mood &&
              link == other.link &&
              performanceNotes == other.performanceNotes &&
              tempoBpm == other.tempoBpm &&
              durationSec == other.durationSec &&
              favorite == other.favorite &&
              createdAt == other.createdAt &&
              updatedAt == other.updatedAt &&
              isSynced == other.isSynced;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      artist.hashCode ^
      mood.hashCode ^
      link.hashCode ^
      performanceNotes.hashCode ^
      tempoBpm.hashCode ^
      durationSec.hashCode ^
      favorite.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isSynced.hashCode;

  MusicEntity copyWith({
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
    return MusicEntity(
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


}


