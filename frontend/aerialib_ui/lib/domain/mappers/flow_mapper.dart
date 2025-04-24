import 'package:frontend/data/models/flow_model.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/data/models/flow_pose_model.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/mappers/pose_mapper.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class FlowMapper {
  /// Converts a FlowModel to a FlowEntity.
  /// Requires the list of associated PoseModels, already ordered.
  static FlowEntity modelToEntity({
    required FlowModel flowModel,
    required List<PoseModel> poseModels,
  }) {
    final poses = poseModels.map(PoseMapper.modelToEntity).toList();

    return FlowEntity(
      id: flowModel.id,
      name: flowModel.name,
      poses: poses,
      description: flowModel.description,
      apparatus: flowModel.apparatus,
      createdBy: flowModel.createdBy,
      updatedBy: flowModel.updatedBy,
      createdAt: flowModel.createdAt,
      updatedAt: flowModel.updatedAt,
      isSynced: flowModel.isSynced,
    );
  }

  /// Converts a FlowEntity to a FlowModel (metadata only)
  static FlowModel entityToModel(FlowEntity entity) {
    return FlowModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      apparatus: entity.apparatus,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  /// Converts FlowEntity's pose list into ordered FlowPoseModels
  static List<FlowPoseModel> entityToFlowPoseModels(FlowEntity entity) {
    return List.generate(entity.poses.length, (index) {
      final pose = entity.poses[index];
      return FlowPoseModel(
        id: _uuid.v6(),
        flowId: entity.id,
        poseId: pose.id,
        order: index,
        transitionId: '', //TODO remove? transition notes stored in flow?
        isSynced: 0,
      );
    });
  }

  /// Helper to convert flowPoseModels → poseModels from local storage
  static Future<List<PoseModel>> flowPoseModelsToPoseModels(
      List<FlowPoseModel> flowPoses,
      Future<PoseModel?> Function(String id) getPoseById,
      ) async {
    final poseModels = <PoseModel>[];
    for (final flowPose in flowPoses) {
      final pose = await getPoseById(flowPose.poseId);
      if (pose != null) {
        poseModels.add(pose);
      } else {
        print("Pose ${flowPose.poseId} not found.");
      }
    }
    return poseModels;
  }
}
