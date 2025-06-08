import 'package:frontend/features/media/data/models/media_model.dart';
import 'package:frontend/features/media/domain/entities/media_entity.dart';

class MediaMapper {
  /// Convert a MediaModel to a MediaEntity
  static MediaEntity modelToEntity(MediaModel model) {
    return MediaEntity(
      id: model.id,
      mediaPath: model.mediaPath,
      mediaType: model.mediaType,
      fileSize: model.fileSize,
      durationSeconds: model.durationSeconds,
      name: model.name,
      description: model.description,
      apparatus: model.apparatus,
      origin: model.origin,
      takenTime: model.takenTime,
      takenLocation: model.takenLocation,
      createdBy: model.createdBy,
      updatedBy: model.updatedBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isSynced: model.isSynced,
    );
  }

  /// Convert a MediaEntity to a MediaModel
  static MediaModel entityToModel(MediaEntity entity) {
    return MediaModel(
      id: entity.id,
      mediaPath: entity.mediaPath,
      mediaType: entity.mediaType,
      fileSize: entity.fileSize,
      durationSeconds: entity.durationSeconds,
      name: entity.name,
      description: entity.description,
      apparatus: entity.apparatus,
      origin: entity.origin,
      takenTime: entity.takenTime,
      takenLocation: entity.takenLocation,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  /// Convert a list of MediaModels to a list of MediaEntities
  static List<MediaEntity> modelsToEntities(List<MediaModel> models) {
    return models.map(modelToEntity).toList();
  }

  /// Convert a list of MediaEntities to a list of MediaModels
  static List<MediaModel> entitiesToModels(List<MediaEntity> entities) {
    return entities.map(entityToModel).toList();
  }
}
