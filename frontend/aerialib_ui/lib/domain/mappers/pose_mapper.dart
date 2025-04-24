import '../../data/models/pose_model.dart';
import '../entities/pose_entity.dart';

class PoseMapper {
  /// Convert a PoseModel to a PoseEntity
  static PoseEntity poseModelToEntity(PoseModel model) {
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
  static PoseModel poseEntityToModel(PoseEntity entity) {
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
  static List<PoseEntity> poseModelsToEntities(List<PoseModel> models) {
    return models.map(poseModelToEntity).toList();
  }

  /// Convert a list of PoseEntities to a list of PoseModels
  static List<PoseModel> poseEntitiesToModels(List<PoseEntity> entities) {
    return entities.map(poseEntityToModel).toList();
  }
}
