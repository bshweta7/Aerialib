import 'dart:developer';

import 'package:frontend/features/flow/data/models/flow_pose_model.dart';

import 'package:frontend/features/pose/data/datasources/pose/pose_local_data.dart';
import 'package:frontend/features/flow/data/datasources/flow_poses/flow_pose_local_data.dart';
import 'package:frontend/features/flow/data/datasources/flow_poses/flow_pose_remote_data.dart';
import 'package:frontend/features/transitions/data/transition_local_data.dart';

import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/flow/domain/entities/flow_pose_entity.dart';

import 'package:frontend/features/flow/domain/mappers/flow_pose_mapper.dart';
import 'package:frontend/features/pose/domain/mappers/pose_mapper.dart';

import '../../../transitions/domain/transition_mapper.dart';

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

  /// Insert a list of flow pose entities
  Future<List<FlowPoseEntity>> createFlowPoses({
    required List<FlowPoseEntity> flowPoses,
    required String token,
  }) async {
    try {
      log('[FlowPoseRepository] Creating flow remotely...');
      final flowPoseModels = FlowPoseMapper.entitiesToModels(flowPoses);

      final createdModels = await remoteDataSource.createFlowPoses(
        flowPoses: flowPoseModels,
        token: token,
      );

      await localDataSource.createFlowPoses(createdModels);

      // final poseModel = await poseLocalDataSource.getPoseById(poseId);
      // if (poseModel == null) {
      //   throw Exception('Pose not found locally for poseId $poseId');
      // }
      //
      // // 4. Get transition model (optional)
      // final TransitionModel? transitionModel = createdModel.transitionId != null
      //     ? await transitionLocalDataSource.getTransitionById(createdModel.transitionId!)
      //     : null;
      //
      // // 5. Map everything to entity
      // return FlowPoseMapper.modelToEntity(
      //   model: createdModel,
      //   poseModel: poseModel,
      //   transitionModel: transitionModel,
      // );

      return flowPoses;
    } catch (e) {
      log('[FlowPoseRepository] Error creating flowPose: $e');
      rethrow;
    }
  }

  /// Fetch all flow poses from local DB
  Future<List<FlowPoseEntity>> getAllFlowPoses() async {
    log("[FlowPoseRepository] Fetching Flow Pose Models from Local Database");
    final flowPoseModels = await localDataSource.getAllFlowPoses();

    log("[FlowPoseRepository] Preparing corresponding Pose Models from Local Database");
    final poseIds = flowPoseModels.map((fp) => fp.poseId).toSet().toList();
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

    log("[FlowPoseRepository] Converting Flow Pose Models to Entities");
    return flowPoseModels.map((fpModel) {
      final poseModel = poseMap[fpModel.poseId];
      if (poseModel == null) {
        throw Exception('[FlowPoseRepository] PoseModel not found for poseId ${fpModel.poseId}');
      }

      final transitionModel = fpModel.transitionId != null
          ? transitionMap[fpModel.transitionId!]
          : null;

      final poseEntity = PoseMapper.modelToEntity(poseModel);
      final transitionEntity = transitionModel != null
          ? TransitionMapper.modelToEntity(transitionModel)
          : null;

      return FlowPoseMapper.modelToEntity(fpModel, poseEntity, transitionEntity);
    }).toList();
  }

  // TODO : see if needed (this will stop gracefully if a pose is not found:
//   final List<FlowPoseEntity> flowPoseEntities = [];
//
//   for (final flowPose in flowPoseModels) {
//   final poseModel = poseMap[flowPose.poseId];
//   if (poseModel == null) {
//   log('⚠️ Warning: PoseModel not found for poseId ${flowPose.poseId}. Skipping.');
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
    final List<FlowPoseModel> flowPoseModels = await remoteDataSource.getRemoteFlowPoses(token: token);
    await localDataSource.createFlowPoses(flowPoseModels);
  }

  /// Send unsynced local flow poses to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<FlowPoseModel> unsynced = await localDataSource.getUnsyncedFlowPoses();
    if (unsynced.isEmpty) return;

    log("[FlowPoseRepository] Retrieved ${unsynced.length} unsynced flow poses from local");

    final success = await remoteDataSource.syncFlowPoses(
      token: token,
      flowPoses: unsynced,
    );

    if (success) {
      for (final pose in unsynced) {
        await localDataSource.updateSyncStatus(pose.id, 1);
      }
      log("[FlowPoseRepository] All unsynced flow poses synced and marked as synced");
    } else {
      log("[FlowPoseRepository] Sync failed for flow poses");
    }
  }


  /// Delete Flow Pose by ID(remote first, then local)
  Future<void> deleteFlowPose({
    required String flowPoseId,
    required String token,
  }) async {
    await remoteDataSource.deleteFlowPose(flowPoseId: flowPoseId, token: token);
    await localDataSource.deleteFlowPoseById(flowPoseId);
    log('[FlowPoseRepository] Flow pose $flowPoseId deleted from both remote and local.');
  }

  /// Delete locally
  Future<void> deleteFlowPoseLocally(String id) async {
    await localDataSource.deleteFlowPoseById(id);
  }

  /// Delete all flow poses associated with a flow ID
  Future<void> deleteAllFlowPosesInFlow({
    required String flowId,
    required String token,
  }) async {
    await remoteDataSource.deleteFlowPosesByFlowId(
      flowId: flowId,
      token: token
    );
    await localDataSource.deleteFlowPosesByFlowId(flowId);
  }


  // /// Update flow poses for a given flow
  // Future<void> replaceFlowPosesInFlow({
  //   required String flowId,
  //   required List<FlowPoseEntity> newPoses,
  //   required String token,
  // }) async {
  //
  //   for (final p in newPoses) {
  //     log('[FlowPoseRepository] id=${p.id}, flowId=${p.flowId}, poseId=${p.pose.id}, poseOrder=${p.poseOrder}');
  //   }
  //
  //   log("[FlowPoseRepository] Deleting all flow poses in flow $flowId");
  //   await deleteAllFlowPosesInFlow(flowId);
  //
  //   log("[FlowPoseRepository] Inserting updated poses into flow...");
  //   await insertFlowPoses(newPoses);
  //
  //   // log("[FlowPoseRepository] Syncing to remote data source...");
  //   // await syncLocalToRemote(token);
  // }


  /// Fetch all poses from local DB
  Future<List<PoseEntity>> getAllLocalPoses() async {
    log("[FlowPoseRepository] Fetching PoseModels for Flow Cubit");
    final poseModels = await poseLocalDataSource.getAllPoses();

    return PoseMapper.modelsToEntities(poseModels);
  }

}
