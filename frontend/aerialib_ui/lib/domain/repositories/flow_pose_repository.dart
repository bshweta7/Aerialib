import 'package:frontend/data/datasources/flows/flow_local_data.dart';
import 'package:frontend/data/datasources/flows/flow_remote_data.dart';
import 'package:frontend/domain/entities/flow_entity.dart';

import '../../data/datasources/poses/pose_local_data.dart';
import '../../data/models/flow_model.dart';
import '../../data/models/flow_pose_model.dart';
import '../entities/pose_entity.dart';
import '../mappers/flow_mapper.dart';
import 'package:frontend/data/datasources/flow_poses/flow_pose_local_data.dart';
import 'package:frontend/data/datasources/flow_poses/flow_pose_remote_data.dart';
import 'package:frontend/domain/entities/flow_pose_entity.dart';
import 'package:frontend/domain/mappers/flow_pose_mapper.dart';

import '../mappers/pose_mapper.dart';
import 'package:frontend/data/datasources/transitions/transition_local_data.dart';
import 'package:frontend/data/models/transition_model.dart';

class FlowPoseRepository {
  final FlowPoseLocalDataSource localDataSource;
  final FlowPoseRemoteDataSource remoteDataSource;
  final PoseLocalDataSource poseLocalDataSource;
  final TransitionLocalDataSource transitionLocalDataSource;

  FlowPoseRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.poseLocalDataSource,
    required this.transitionLocalDataSource,
  });

  /// Create a new flow pose (tries remote first, fallback to local if offline)
  Future<FlowPoseEntity> createFlowPose({
    required String flowId,
    required String poseId,
    required int poseOrder,
    String? transitionId,
    required String token,
  }) async {
    try {
      final createdModel = await remoteDataSource.createFlowPose(
        flowId: flowId,
        poseId: poseId,
        poseOrder: poseOrder,
        transitionId: transitionId,
        token: token,
      );

      await localDataSource.insertFlowPose(createdModel);

      final poseModel = await poseLocalDataSource.getPoseById(poseId);
      if (poseModel == null) {
        throw Exception('Pose not found locally for poseId $poseId');
      }

      final TransitionModel? transitionModel = createdModel.transitionId != null
          ? await transitionLocalDataSource.getTransitionById(createdModel.transitionId!)
          : null;

      return FlowPoseMapper.modelToEntity(
        model: createdModel,
        poseModel: poseModel,
        transitionModel: transitionModel,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Insert a list of flow pose entities
  Future<void> insertFlowPoses(List<FlowPoseEntity> entities) async {
    final models = entities.map(FlowPoseMapper.entityToModel).toList();
    await localDataSource.insertFlowPoses(models);
  }



  /// Fetch all flow poses from local DB
  Future<List<FlowPoseEntity>> getLocalFlowPoses() async {
    print("Fetching Flow Pose Models from Local Database");
    final flowPoseModels = await localDataSource.getFlowPoses();

    print("Preparing corresponding Pose Models from Local Database");
    final poseIds = flowPoseModels.map((fp) => fp.poseId).toList();
    final poseModels = await poseLocalDataSource.getPosesByIds(poseIds);
    final poseMap = {for (var pose in poseModels) pose.id: pose};

    final transitionIds = flowPoseModels
        .map((fp) => fp.transitionId)
        .where((id) => id != null)
        .cast<String>()
        .toSet()
        .toList();

    final transitionModels = await transitionLocalDataSource.getTransitionsByIds(transitionIds);
    final transitionMap = {for (var t in transitionModels) t.id: t};

    print("Converting to Flow Pose Models to Entities");
    return flowPoseModels.map((flowPose) {
      final poseModel = poseMap[flowPose.poseId];
      if (poseModel == null) {
        throw Exception('PoseModel not found for poseId ${flowPose.poseId}');
      }

      final transitionModel = flowPose.transitionId != null
          ? transitionMap[flowPose.transitionId!]
          : null;

      return FlowPoseMapper.modelToEntity(
        model: flowPose,
        poseModel: poseModel,
        transitionModel: transitionModel,
      );
    }).toList();
  }
  // TODO : see if needed (this will stop gracefully if a pose is not found:
//   final List<FlowPoseEntity> flowPoseEntities = [];
//
//   for (final flowPose in flowPoseModels) {
//   final poseModel = poseMap[flowPose.poseId];
//   if (poseModel == null) {
//   print('⚠️ Warning: PoseModel not found for poseId ${flowPose.poseId}. Skipping.');
//   continue; // skip this one
//   }
//   flowPoseEntities.add(
//   FlowPoseMapper.modelToEntity(
//   model: flowPose,
//   poseModel: poseModel,
//   ),
//   );
//   }
//
//   return flowPoseEntities;
// }




// TODO - should it "sync" or just delete and readd? double check how sync function is working.

  /// Fetch all flow poses from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    final List<FlowPoseModel> flowPoseModels = await remoteDataSource.fetchRemoteFlowPoses(token: token);
    await localDataSource.insertFlowPoses(flowPoseModels);
  }

  /// Send unsynced local flow poses to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<FlowPoseModel> unsynced = await localDataSource.getUnsyncedFlowPoses();
    if (unsynced.isEmpty) {
      return;
    }

    print("Retrieved unsynced flow poses from local");
    final success = await remoteDataSource.syncFlowPoses(
      token: token,
      flowPoses: unsynced,
    );
    print("Synced flow poses to remote");

    if (success) {
      for (final flow in unsynced) {
        await localDataSource.setSyncedStatus(flow.id, 1);
      }
      print("Updated flow poses synced status to synced");
    }
  }

  /// Delete locally
  Future<void> deleteFlowPose(String id) async {
    await localDataSource.deleteFlowPose(id);
  }

  /// Delete all flow poses associated with a flow ID
  Future<void> deleteAllFlowPosesInFlow(String flowId) async {
    await localDataSource.deleteFlowPoseInFlow(flowId);
  }


  /// Update flow poses for a given flow
  Future<void> replaceFlowPosesInFlow({
    required String flowId,
    required List<FlowPoseEntity> newPoses,
  }) async {
    await deleteAllFlowPosesInFlow(flowId);
    await insertFlowPoses(newPoses);
  }


  /// Fetch all poses from local DB
  Future<List<PoseEntity>> getAllLocalPoses() async {
    print("Fetching PoseModels for Flow Cubit");
    final poseModels = await poseLocalDataSource.getAllPoses();
    return PoseMapper.modelsToEntities(poseModels);
  }

}
