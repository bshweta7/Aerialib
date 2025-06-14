import 'package:frontend/features/flow/data/models/flow_pose_model.dart';
import 'package:frontend/features/flow/domain/entities/flow_pose_entity.dart';
import 'package:frontend/features/flow/presentation/display_models/flow_pose_display_model.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/transitions/domain/transition_entity.dart';

class FlowPoseMapper {
  /// Model → Entity
  static FlowPoseEntity modelToEntity(
      FlowPoseModel model,
      PoseEntity poseEntity,
      TransitionEntity? transitionEntity
      ) {
    return FlowPoseEntity(
      id: model.id,
      flowId: model.flowId,
      pose: poseEntity,
      poseOrder: model.poseOrder,
      transition: transitionEntity,
      isSynced: model.isSynced,
    );
  }

  /// Bulk Model to Entity
  static List<FlowPoseEntity> modelsToEntities(
      List<FlowPoseModel> models,
      List<PoseEntity> poses,
      List<TransitionEntity> transitions,
      ) {
    return List.generate(models.length, (i) {
      return modelToEntity(models[i], poses[i], transitions[i]);
    });
  }

  /// Entity → Model
  static FlowPoseModel entityToModel(FlowPoseEntity entity) {
    return FlowPoseModel(
      id: entity.id,
      flowId: entity.flowId,
      poseId: entity.pose.id,
      poseOrder: entity.poseOrder,
      transitionId: entity.transition?.id,
      isSynced: entity.isSynced,
    );
  }

  /// Bulk: Entities → Models
  static List<FlowPoseModel> entitiesToModels(List<FlowPoseEntity> entities) {
    return entities.map(entityToModel).toList();
  }

  // /// Entity + Pose + Transition → DisplayModel
  // static FlowPoseDisplayModel toDisplayModel({
  //   required FlowPoseEntity entity,
  //   required PoseEntity pose,
  //   TransitionEntity? transition,
  // }) {
  //   return FlowPoseDisplayModel(
  //     flowPose: entity,
  //     pose: pose,
  //     transition: transition,
  //   );
  // }
  //
  // /// Bulk: Map FlowPoseEntity list to FlowPoseDisplayModels using lookup maps
  // static List<FlowPoseDisplayModel> toDisplayModels({
  //   required List<FlowPoseEntity> flowPoses,
  //   required Map<String, PoseEntity> poseMap,
  //   required Map<String, TransitionEntity> transitionMap,
  // }) {
  //   return flowPoses.map((fp) {
  //     final pose = poseMap[fp.poseId];
  //     final transition = fp.transitionId != null ? transitionMap[fp.transitionId!] : null;
  //
  //     if (pose == null) {
  //       throw Exception('[FlowPoseMapper] Missing pose for ID: ${fp.poseId}');
  //     }
  //
  //     return toDisplayModel(entity: fp, pose: pose, transition: transition);
  //   }).toList();
  // }
}
