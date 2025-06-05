import 'dart:developer';

import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/pose/domain/mappers/pose_mapper.dart';

import 'package:frontend/features/pose/data/datasources/pose/pose_local_data.dart';
import 'package:frontend/features/pose/data/datasources/pose/pose_remote_data.dart';
import 'package:frontend/features/pose/data/models/pose_model.dart';


class PoseRepository {
  final PoseLocalDataSource localDataSource;
  final PoseRemoteDataSource remoteDataSource;

  PoseRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Create a new pose (tries remote first, fallback to local if offline)
  Future<PoseEntity> createPose({
    required PoseEntity pose,
    required String token,
  }) async {
    try {
      log('[PoseRepository] Creating pose remotely...');

      // Convert to model and send to backend
      final poseModel = await remoteDataSource.createPose(
        pose: PoseMapper.entityToModel(pose),
        token: token,
      );

      // Save to local DB
      await localDataSource.insertPose(poseModel);
      log('[PoseRepository] Pose inserted into local database.');

      // Return as entity
      final entity = PoseMapper.modelToEntity(poseModel);
      log('[PoseRepository] Mapped PoseModel to PoseEntity: ${entity.id}');
      return entity;

    } catch (e) {
      log('[PoseRepository] Error creating pose: $e');
      rethrow;
    }
  }



  /// Fetch all poses from local DB
  Future<List<PoseEntity>> getAllPoses() async {
    log('[PosesRepository] Fetching PoseModels from local database... ');

    final poseModels = await localDataSource.getAllPoses();

    // log('[PosesRepository] Converting models to entities');
    final poseEntitiesList = PoseMapper.modelsToEntities(poseModels);
    log('[PosesRepository] Got ${poseModels.length} pose entities');
    // log('[PosesRepository] Conversion complete');

    return poseEntitiesList;
  }

  // TODO get all poses - try to sync and if not possible, return local poses with note that its local only (or last synced time)

  /// Fetch all poses from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    final poseModels = await remoteDataSource.fetchRemotePoses(token: token);
    // log(poseModels);
    await localDataSource.insertPoses(poseModels);
  }


  /// Send unsynced local poses to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<PoseModel> unsynced = await localDataSource.getUnsyncedPoses();
    if (unsynced.isEmpty) {
      return;
    }

    log("[PoseRepository] Retrieved unsynced poses from local");
    final success = await remoteDataSource.syncPoses(
      token: token,
      poses: unsynced,
    );
    log("[PoseRepository] Synced poses to remote");

    if (success) {
      for (final pose in unsynced) {
        await localDataSource.setSyncedStatus(pose.id, 1);
      }
    }
  }

  // /// Full sync (both directions)
  // Future<void> fullSync(String token) async {
  //   await syncLocalToRemote(token);
  //   await syncRemoteToLocal(token);
  // }

  /// Update a pose remotely and locally
  Future<void> updatePose({
    required PoseEntity updatedPose,
    required String token,
  }) async {
    final poseModel = PoseMapper.entityToModel(updatedPose);

    log("[PoseRepository] Updating pose remotely...");
    final updatedModel = await remoteDataSource.updatePose(
      updatedPose: poseModel,
      token: token,
    );

    log("[PoseRepository] Updating pose locally...");
    final syncedModel = updatedModel.copyWith(isSynced: 1);
    await localDataSource.updatePose(syncedModel);
  }

  /// Delete locally
  Future<void> deletePose(String id) async {
    await localDataSource.deletePose(id);
  }
}