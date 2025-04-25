import 'package:frontend/data/models/flow_model.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/data/models/flow_pose_model.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/mappers/pose_mapper.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/constants.dart';
import '../entities/flow_pose_entity.dart';
import 'flow_pose_mapper.dart';

class FlowMapper {

  /// Converts a FlowModel to a FlowEntity with empty poses.
  static FlowEntity modelToEntityMetaDataOnly(FlowModel flowModel) {
    return FlowEntity(
      id: flowModel.id,
      name: flowModel.name,
      description: flowModel.description,
      apparatus: flowModel.apparatus,
      poses: [],
      // Empty, to be filled later
      createdBy: flowModel.createdBy,
      updatedBy: flowModel.updatedBy,
      createdAt: flowModel.createdAt,
      updatedAt: flowModel.updatedAt,
      isSynced: flowModel.isSynced,
    );
  }

  /// Converts a FlowModel to a FlowEntity.
  /// Requires the list of associated PoseModels, already ordered.
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
          FlowPoseMapper.modelToEntity(model: model, poseModel: poseModel),
        );
      }
    }

    return FlowEntity(
      id: flowModel.id,
      name: flowModel.name,
      description: flowModel.description,
      apparatus: flowModel.apparatus,
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
    final primaryImageId = entity.poses.isNotEmpty ? entity.poses.first.pose.primaryImageId : '';
    final primaryImageUrl = entity.poses.isNotEmpty ? entity.poses.first.pose.primaryImageUrl : Constants.missingImageUrl;


    return FlowModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      apparatus: entity.apparatus,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      primaryImageId: primaryImageId,
      primaryImageUrl: primaryImageUrl,
      isSynced: entity.isSynced,
    );
  }
}
