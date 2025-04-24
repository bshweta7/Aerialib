import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/domain/entities/pose_entity.dart';

class PoseMapper {
  /// Convert a PoseModel to a PoseEntity
  static PoseEntity modelToEntity(PoseModel model) {
    return PoseEntity(
      id: model.id,
      name: model.name,
      description: model.description,
      cues: model.cues,
      apparatus: model.apparatus,
      level: model.level,
      createdBy: model.createdBy,
      updatedBy: model.updatedBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isSynced: model.isSynced,
      primaryImageId: model.primaryImageId,
      primaryImageUrl: model.primaryImageUrl,
    );
  }

  /// Convert a PoseEntity to a PoseModel
  static PoseModel entityToModel(PoseEntity entity) {
    return PoseModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      cues: entity.cues,
      apparatus: entity.apparatus,
      level: entity.level,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
      primaryImageId: entity.primaryImageId,
      primaryImageUrl: entity.primaryImageUrl,
    );
  }
  /// Convert a list of PoseModels to a list of PoseEntities
  static List<PoseEntity> modelsToEntities(List<PoseModel> models) {
    return models.map(modelToEntity).toList();
  }

  /// Convert a list of PoseEntities to a list of PoseModels
  static List<PoseModel> entitiesToModels(List<PoseEntity> entities) {
    return entities.map(entityToModel).toList();
  }
}
