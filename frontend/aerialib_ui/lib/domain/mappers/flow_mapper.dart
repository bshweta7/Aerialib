import 'package:frontend/data/models/flow_model.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/data/models/flow_pose_model.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import '../entities/flow_pose_entity.dart';
import 'flow_pose_mapper.dart';

class FlowMapper {
  /// Converts a FlowModel to a FlowEntity with empty poses.
  static FlowEntity modelToEntityMetaDataOnly(FlowModel flowModel) {
    return FlowEntity(
      id: flowModel.id,
      name: flowModel.name,
      thumbnailImageId: flowModel.thumbnailImageId,
      thumbnailImagePath: flowModel.thumbnailImagePath,
      apparatus: flowModel.apparatus,
      level: flowModel.level,
      description: flowModel.description,
      teachingCues: flowModel.teachingCues,
      safetyCues: flowModel.safetyCues,
      progressions: flowModel.progressions,
      poses: [],
      createdBy: flowModel.createdBy,
      updatedBy: flowModel.updatedBy,
      createdAt: flowModel.createdAt,
      updatedAt: flowModel.updatedAt,
      isSynced: flowModel.isSynced,
    );
  }

  /// Converts a FlowModel to a full FlowEntity with ordered pose data.
  static Future<FlowEntity> modelToFullEntity({
    required FlowModel flowModel,
    required List<FlowPoseModel> flowPoseModels,
    required Future<PoseModel?> Function(String id) getPoseById,
  }) async {
    final List<FlowPoseEntity> flowPoseEntities = [];

    for (final model in flowPoseModels) {
      final poseModel = await getPoseById(model.poseId);
      if (poseModel != null) {
        flowPoseEntities.add(
          FlowPoseMapper.modelToEntity(
              model: model,
              poseModel: poseModel,
              // TODO transitionModel: transitionModel
          ),
        );
      }
    }

    return FlowEntity(
      id: flowModel.id,
      name: flowModel.name,
      thumbnailImageId: flowModel.thumbnailImageId,
      thumbnailImagePath: flowModel.thumbnailImagePath,
      apparatus: flowModel.apparatus,
      level: flowModel.level,
      description: flowModel.description,
      teachingCues: flowModel.teachingCues,
      safetyCues: flowModel.safetyCues,
      progressions: flowModel.progressions,
      poses: flowPoseEntities,
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
      thumbnailImageId: entity.thumbnailImageId,
      thumbnailImagePath: entity.thumbnailImagePath,
      apparatus: entity.apparatus,
      level: entity.level,
      description: entity.description,
      teachingCues: entity.teachingCues,
      safetyCues: entity.safetyCues,
      progressions: entity.progressions,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }
}
