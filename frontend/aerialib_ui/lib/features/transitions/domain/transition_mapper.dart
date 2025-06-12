import 'package:frontend/features/transitions/data/transition_model.dart';
import 'package:frontend/features/transitions/domain/transition_entity.dart';

import '../../pose/domain/entities/pose_entity.dart';
import '../presentation/transition_display_model.dart';

class TransitionMapper {

  /// Create a TransitionEntity from a TransitionModel
  static TransitionEntity modelToEntity(TransitionModel model) {
    return TransitionEntity(
      id: model.id,
      fromPoseId: model.fromPoseId,
      toPoseId: model.toPoseId,
      name: model.name,
      apparatus: model.apparatus,
      level: model.level,
      transitionType: model.transitionType,
      description: model.description,
      teachingCues: model.teachingCues,
      safetyCues: model.safetyCues,
      progressions: model.progressions,
      modifications: model.modifications,
      commonErrors: model.commonErrors,
      primaryMediaId: model.primaryMediaId,
      primaryMediaPath: model.primaryMediaPath,
      createdBy: model.createdBy,
      updatedBy: model.updatedBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isSynced: model.isSynced,
    );
  }

  /// Bulk conversion of TransitionModels to TransitionEntities
  static List<TransitionEntity> modelsToEntities(List<TransitionModel> models) {
    return models.map(modelToEntity).toList();
  }

  /// Create a TransitionModel from a TransitionEntity
  static TransitionModel entityToModel(TransitionEntity entity) {
    return TransitionModel(
      id: entity.id,
      fromPoseId: entity.fromPoseId,
      toPoseId: entity.toPoseId,
      name: entity.name,
      apparatus: entity.apparatus,
      level: entity.level,
      transitionType: entity.transitionType,
      description: entity.description,
      teachingCues: entity.teachingCues,
      safetyCues: entity.safetyCues,
      progressions: entity.progressions,
      modifications: entity.modifications,
      commonErrors: entity.commonErrors,
      primaryMediaId: entity.primaryMediaId,
      primaryMediaPath: entity.primaryMediaPath,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  /// Bulk conversion of TransitionEntities to TransitionModels
  static List<TransitionModel> entitiesToModels(List<TransitionEntity> entities) {
    return entities.map(entityToModel).toList();
  }

  /// Create a TransitionDisplayModel from a TransitionEntity and a poseMap
  static TransitionDisplayModel entityToDisplayModel({
    required TransitionEntity transition,
    required Map<String, PoseEntity> poseMap,
  }) {
    final fromPose = poseMap[transition.fromPoseId];
    final toPose = poseMap[transition.toPoseId];

    if (fromPose == null || toPose == null) {
      throw Exception('Missing pose(s) for transition: ${transition.id}');
    }

    return TransitionDisplayModel(
      transition: transition,
      fromPose: fromPose,
      toPose: toPose,
    );
  }

  /// Bulk conversion of transition entities to display models
  static List<TransitionDisplayModel> entitiesToDisplayModels({
    required List<TransitionEntity> transitions,
    required Map<String, PoseEntity> poseMap,
  }) {
    return transitions
        .where((t) =>
    poseMap.containsKey(t.fromPoseId) && poseMap.containsKey(t.toPoseId))
        .map((t) => entityToDisplayModel(transition: t, poseMap: poseMap))
        .toList();
  }
}