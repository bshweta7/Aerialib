import 'pose_mapper.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/data/models/flow_pose_model.dart';
import 'package:frontend/domain/entities/flow_pose_entity.dart';

class FlowPoseMapper {
  static FlowPoseEntity modelToEntity({
    required FlowPoseModel model,
    required PoseModel poseModel,
  }) {
    return FlowPoseEntity(
      id: model.id,
      flowId: model.flowId,
      pose: PoseMapper.modelToEntity(poseModel),
      order: model.order,
    );
  }

  static FlowPoseModel entityToModel(FlowPoseEntity entity) {
    return FlowPoseModel(
      id: entity.id,
      flowId: entity.flowId,
      poseId: entity.pose.id,
      order: entity.order,
      transitionId: '',
      isSynced: 0,
    );
  }
}


//   /// Converts FlowEntity's pose list into ordered FlowPoseModels
//   static List<FlowPoseModel> entityToFlowPoseModels(FlowEntity entity) {
//     return List.generate(entity.poses.length, (index) {
//       final pose = entity.poses[index];
//       return FlowPoseModel(
//         id: _uuid.v6(),
//         flowId: entity.id,
//         poseId: pose.id,
//         order: index,
//         transitionId: '', //TODO remove? transition notes stored in flow?
//         isSynced: 0,
//       );
//     });
//   }
//
//   /// Helper to convert flowPoseModels → poseModels from local storage
//   static Future<List<PoseModel>> flowPoseModelsToPoseModels(
//       List<FlowPoseModel> flowPoses,
//       Future<PoseModel?> Function(String id) getPoseById,
//       ) async {
//     final poseModels = <PoseModel>[];
//     for (final flowPose in flowPoses) {
//       final pose = await getPoseById(flowPose.poseId);
//       if (pose != null) {
//         poseModels.add(pose);
//       } else {
//         print("Pose ${flowPose.poseId} not found.");
//       }
//     }
//     return poseModels;
//   }
// }
