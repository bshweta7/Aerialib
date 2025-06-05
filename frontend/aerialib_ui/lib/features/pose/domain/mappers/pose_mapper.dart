import 'package:frontend/features/pose/data/models/pose_model.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';

class PoseMapper {
  /// Convert a PoseModel to a PoseEntity
  static PoseEntity modelToEntity(PoseModel model) {
    return PoseEntity(
      id: model.id,
      slug: model.slug,
      displayName: model.displayName,
      altName: model.altName,
      baseName: model.baseName,
      prefix: model.prefix,
      suffix: model.suffix,
      handPosition: model.handPosition,
      legPosition: model.legPosition,
      positionInBar: model.positionInBar,
      apparatus: model.apparatus,
      level: model.level,
      poseType: model.poseType,
      description: model.description,
      teachingCues: model.teachingCues,
      safetyCues: model.safetyCues,
      progressions: model.progressions,
      modifications: model.modifications,
      commonErrors: model.commonErrors,
      primaryMediaId: model.primaryMediaId,
      primaryMediaPath: model.primaryMediaPath,
      thumbnailMediaId: model.thumbnailMediaId,
      thumbnailMediaPath: model.thumbnailMediaPath,
      createdBy: model.createdBy,
      updatedBy: model.updatedBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isSynced: model.isSynced,
    );
  }

  /// Convert a PoseEntity to a PoseModel
  static PoseModel entityToModel(PoseEntity entity) {
    return PoseModel(
      id: entity.id,
      slug: entity.slug,
      displayName: entity.displayName,
      altName: entity.altName,
      baseName: entity.baseName,
      prefix: entity.prefix,
      suffix: entity.suffix,
      handPosition: entity.handPosition,
      legPosition: entity.legPosition,
      positionInBar: entity.positionInBar,
      apparatus: entity.apparatus,
      level: entity.level,
      poseType: entity.poseType,
      description: entity.description,
      teachingCues: entity.teachingCues,
      safetyCues: entity.safetyCues,
      progressions: entity.progressions,
      modifications: entity.modifications,
      commonErrors: entity.commonErrors,
      primaryMediaId: entity.primaryMediaId,
      primaryMediaPath: entity.primaryMediaPath,
      thumbnailMediaId: entity.thumbnailMediaId,
      thumbnailMediaPath: entity.thumbnailMediaPath,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
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
