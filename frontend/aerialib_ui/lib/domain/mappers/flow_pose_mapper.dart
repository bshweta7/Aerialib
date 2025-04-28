import 'pose_mapper.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/data/models/flow_pose_model.dart';
import 'package:frontend/domain/entities/flow_pose_entity.dart';

class FlowPoseMapper {
  /// Converts a FlowPoseModel and its linked PoseModel to a FlowPoseEntity
  static FlowPoseEntity modelToEntity({
    required FlowPoseModel model,
    required PoseModel poseModel,
  }) {
    return FlowPoseEntity(
      id: model.id,
      flowId: model.flowId,
      pose: PoseMapper.modelToEntity(poseModel),
      poseOrder: model.poseOrder,
    );
  }

  /// Converts a FlowPoseEntity back into a FlowPoseModel
  static FlowPoseModel entityToModel(FlowPoseEntity entity) {
    return FlowPoseModel(
      id: entity.id,
      flowId: entity.flowId,
      poseId: entity.pose.id,  // ✨ be careful — it's pose.id, NOT entity.id again
      poseOrder: entity.poseOrder,
      transitionId: '', // TODO remove this from schema
      isSynced: 0, // optional
    );
  }
}