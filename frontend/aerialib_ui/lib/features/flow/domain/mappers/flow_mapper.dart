import 'package:frontend/features/flow/data/models/flow_model.dart';
import 'package:frontend/features/flow/domain/entities/flow_entity.dart';

import '../entities/flow_pose_entity.dart';


class FlowMapper {

  /// Converts a FlowModel to a FlowEntity
  static FlowEntity modelToEntity(
      FlowModel model,
      // List<FlowPoseEntity> flowPoses
    ) {

    return FlowEntity(
      id: model.id,
      name: model.name,
      apparatus: model.apparatus,
      level: model.level,
      // flowPoses: flowPoses,
      flowPoses: [],
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

  /// Bulk conversion of FlowModel to FlowEntity with attached FlowPoseEntities
  static List<FlowEntity> modelsToEntities(
      List<FlowModel> models,
      // List<List<FlowPoseEntity>> flowPosesLists,
      ) {
    return List.generate(models.length, (i) {
      return modelToEntity(models[i]);
      // return modelToEntity(models[i], flowPosesLists[i]);
    });
  }

  /// Converts a FlowEntity to a FlowModel
  static FlowModel entityToModel(FlowEntity entity) {
    return FlowModel(
      id: entity.id,
      name: entity.name,
      apparatus: entity.apparatus,
      level: entity.level,
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

  /// Bulk conversion: List<FlowEntity> → List<FlowModel>
  static List<FlowModel> entitiesToModels(List<FlowEntity> entities) {
    return entities.map(entityToModel).toList();
  }

  // /// Convert FlowEntity + display poses → FlowDisplayModel
  // static FlowDisplayModel entityToDisplayModel({
  //   required FlowEntity flow,
  //   required List<FlowPoseDisplayModel> flowPoseDisplayModels,
  // }) {
  //   return FlowDisplayModel(
  //     flow: flow,
  //     flowPoses: flowPoseDisplayModels,
  //   );
  // }
  //
  // /// Convert FlowDisplayModel → FlowEntity and List<FlowPoseEntity>
  // static ({FlowEntity flow, List<FlowPoseEntity> flowPoseEntities}) displayModelToEntity(
  //     FlowDisplayModel displayModel,
  //     ) {
  //   final flow = displayModel.flow;
  //   final poses = displayModel.flowPoses.map((d) => d.flowPose).toList();
  //
  //   return (flow: flow, flowPoseEntities: poses);
  // }
  //
  // /// Bulk: Convert list of FlowEntities + poseDisplayMap → FlowDisplayModels
  // static List<FlowDisplayModel> entitiesToDisplayModels({
  //   required List<FlowEntity> flows,
  //   required Map<String, List<FlowPoseDisplayModel>> poseDisplayMap,
  // }) {
  //   return flows.map((flow) {
  //     final poses = poseDisplayMap[flow.id] ?? [];
  //     return entityToDisplayModel(flow: flow, flowPoseDisplayModels: poses);
  //   }).toList();
  // }
  //
  // /// Bulk: Convert list of FlowDisplayModels → (List<FlowEntity>, List<FlowPoseEntity>)
  // static ({List<FlowEntity> flows, List<FlowPoseEntity> flowPoseEntities})
  // displayModelsToEntities(List<FlowDisplayModel> displayModels) {
  //   final flows = <FlowEntity>[];
  //   final flowPoseEntities = <FlowPoseEntity>[];
  //
  //   for (final model in displayModels) {
  //     flows.add(model.flow);
  //     flowPoseEntities.addAll(model.flowPoses.map((d) => d.flowPose));
  //   }
  //
  //   return (flows: flows, flowPoseEntities: flowPoseEntities);
  // }
}
