import 'package:frontend/data/models/media_model.dart';
import 'package:frontend/domain/entities/media_entity.dart';

class MediaMapper {
  /// Convert a MediaModel to a MediaEntity
  static MediaEntity modelToEntity(MediaModel model) {
    return MediaEntity(
      id: model.id,
      mediaPath: model.path,
      name: model.name,
      description: model.description,
      apparatus: model.apparatus,
      uploadedBy: model.uploadedBy,
      uploadedAt: model.uploadedAt,
      isSynced: model.isSynced,
    );
  }

  /// Convert a MediaEntity to a MediaModel
  static MediaModel entityToModel(MediaEntity entity) {
    return MediaModel(
      id: entity.id,
      path: entity.mediaPath,
      name: entity.name,
      description: entity.description,
      apparatus: entity.apparatus,
      uploadedBy: entity.uploadedBy,
      uploadedAt: entity.uploadedAt,
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
