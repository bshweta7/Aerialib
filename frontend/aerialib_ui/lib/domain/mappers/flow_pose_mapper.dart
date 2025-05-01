import 'pose_mapper.dart';
import 'transition_mapper.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/data/models/flow_pose_model.dart';
import 'package:frontend/data/models/transition_model.dart';
import 'package:frontend/domain/entities/flow_pose_entity.dart';

class FlowPoseMapper {
  /// Converts a FlowPoseModel and its linked PoseModel + TransitionModel to a FlowPoseEntity
  static FlowPoseEntity modelToEntity({
    required FlowPoseModel model,
    required PoseModel poseModel,
    TransitionModel? transitionModel,
  }) {
    return FlowPoseEntity(
      id: model.id,
      flowId: model.flowId,
      pose: PoseMapper.modelToEntity(poseModel),
      poseOrder: model.poseOrder,
      transition: transitionModel != null
          ? TransitionMapper.modelToEntity(transitionModel)
          : null,
    );
  }

  /// Converts a FlowPoseEntity back into a FlowPoseModel
  static FlowPoseModel entityToModel(FlowPoseEntity entity) {
    return FlowPoseModel(
      id: entity.id,
      flowId: entity.flowId,
      poseId: entity.pose.id,
      poseOrder: entity.poseOrder,
      transitionId: entity.transition?.id,
      isSynced: 0,
    );
  }
}
