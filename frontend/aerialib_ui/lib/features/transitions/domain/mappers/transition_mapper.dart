import 'package:frontend/features/transitions/data/models/transition_model.dart';
import 'package:frontend/features/transitions/domain/entities/transition_entity.dart';

class TransitionMapper {
  static TransitionEntity modelToEntity(TransitionModel model) {
    return TransitionEntity(
      id: model.id,
      fromPoseId: model.fromPoseId,
      toPoseId: model.toPoseId,
      level: model.level,
      name: model.name,
      description: model.description,
      teachingCues: model.teachingCues,
      safetyCues: model.safetyCues,
      progressions: model.progressions,
      transitionType: model.transitionType,
      startingGrip: model.startingGrip,
      endingGrip: model.endingGrip,
      createdBy: model.createdBy,
      updatedBy: model.updatedBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isSynced: model.isSynced,
    );
  }

  static TransitionModel entityToModel(TransitionEntity entity) {
    return TransitionModel(
      id: entity.id,
      fromPoseId: entity.fromPoseId,
      toPoseId: entity.toPoseId,
      level: entity.level,
      name: entity.name,
      description: entity.description,
      teachingCues: entity.teachingCues,
      safetyCues: entity.safetyCues,
      progressions: entity.progressions,
      transitionType: entity.transitionType,
      startingGrip: entity.startingGrip,
      endingGrip: entity.endingGrip,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  static List<TransitionEntity> modelsToEntities(List<TransitionModel> models) {
    return models.map(modelToEntity).toList();
  }

  static List<TransitionModel> entitiesToModels(List<TransitionEntity> entities) {
    return entities.map(entityToModel).toList();
  }
}
