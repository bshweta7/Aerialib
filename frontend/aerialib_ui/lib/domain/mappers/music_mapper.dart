// lib/data/mappers/music_mapper.dart

import 'package:frontend/data/models/music_model.dart';
import 'package:frontend/domain/entities/music_entity.dart';

class MusicMapper {
  /// Convert a MusicModel to a MusicEntity
  static MusicEntity modelToEntity(MusicModel model) {
    return MusicEntity(
      id: model.id,
      userId: model.userId,
      name: model.name,
      artist: model.artist,
      mood: model.mood,
      link: model.link,
      performanceNotes: model.performanceNotes,
      tempoBpm: model.tempoBpm,
      durationSec: model.durationSec,
      favorite: model.favorite,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isSynced: model.isSynced,
    );
  }

  /// Convert a MusicEntity to a MusicModel
  static MusicModel entityToModel(MusicEntity entity) {
    return MusicModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      artist: entity.artist,
      mood: entity.mood,
      link: entity.link,
      performanceNotes: entity.performanceNotes,
      tempoBpm: entity.tempoBpm,
      durationSec: entity.durationSec,
      favorite: entity.favorite,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  /// Convert a list of MusicModels to a list of MusicEntities
  static List<MusicEntity> modelsToEntities(List<MusicModel> models) {
    return models.map(modelToEntity).toList();
  }

  /// Convert a list of MusicEntities to a list of MusicModels
  static List<MusicModel> entitiesToModels(List<MusicEntity> entities) {
    return entities.map(entityToModel).toList();
  }
}
