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
      await localDataSource.createPose(poseModel);
      // log('[PoseRepository] Pose inserted into local database.');

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
    // log('[PosesRepository] Fetching PoseModels from local database... ');

    final poseModels = await localDataSource.getAllPoses();

    // log('[PosesRepository] Converting models to entities');
    final poseEntitiesList = PoseMapper.modelsToEntities(poseModels);
    log('[PosesRepository] Got ${poseModels.length} pose entities from local database');
    // log('[PosesRepository] Conversion complete');

    return poseEntitiesList;
  }

  // TODO get all poses - try to sync and if not possible, return local poses with note that its local only (or last synced time)

  /// Fetch all poses from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    try {
      final poseModels = await remoteDataSource.getRemotePoses(token: token);
      await localDataSource.createPoses(poseModels);
      log('[PoseRepository] Synced ${poseModels.length} remote poses to local.');
    } catch (e) {
      log('[PoseRepository] Failed syncing remote poses to local: $e');
      rethrow;
    }
  }

  /// Send unsynced local poses to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<PoseModel> unsynced = await localDataSource.getUnsyncedPoses();
    if (unsynced.isEmpty) {
      log("[PoseRepository] No unsynced poses found.");
      return;
    }

    log("[PoseRepository] Attempting to sync ${unsynced.length} poses to remote...");
    final success = await remoteDataSource.syncPoses(
      token: token,
      poses: unsynced,
    );

    if (success) {
      for (final pose in unsynced) {
        await localDataSource.updateSyncStatus(pose.id, 1);
      }
      log("[PoseRepository] Successfully updated sync status locally.");
    } else {
      log("[PoseRepository] Remote sync failed. Sync status not updated.");
    }
  }

  /// Update a pose remotely and locally using sync
  Future<void> updatePose({
    required PoseEntity updatedPose,
    required String token,
  }) async {
    final poseModel = PoseMapper.entityToModel(updatedPose);

    log("[PoseRepository] Syncing updated pose remotely...");
    final success = await remoteDataSource.syncPoses(
      token: token,
      poses: [poseModel], // Just pass this one updated pose
    );

    if (success) {
      final syncedModel = poseModel.copyWith(isSynced: 1);
      log("[PoseRepository] Updating pose locally...");
      await localDataSource.updatePose(syncedModel);
    } else {
      log("[PoseRepository] Remote sync failed. Pose not updated locally.");
      throw Exception("Failed to update pose remotely via sync.");
    }
  }

  /// Delete Pose
  Future<void> deletePoseRemote({
    required String id,
    required String token,
  }) async {
    await remoteDataSource.deletePose(poseId: id, token: token);
    await localDataSource.deletePose(id);
    log('[PoseRepository] Pose $id deleted from both remote and local.');
  }

}