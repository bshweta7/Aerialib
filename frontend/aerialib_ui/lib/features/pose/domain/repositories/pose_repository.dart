import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/pose/domain/mappers/pose_mapper.dart';

import 'package:frontend/features/pose/data/datasources/pose/pose_local_data.dart';
import 'package:frontend/features/pose/data/datasources/pose/pose_remote_data.dart';
import 'package:frontend/features/pose/data/models/pose_model.dart';
import 'package:uuid/uuid.dart';


class PoseRepository {
  final FirebaseFirestore _firestore;
  final PoseLocalDataSource localDataSource;
  final PoseRemoteDataSource remoteDataSource;

  PoseRepository({
    FirebaseFirestore? firestore,
    required this.localDataSource,
    required this.remoteDataSource,
  }): _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create a new pose
   Future<PoseEntity> createPose({
    required PoseEntity pose,
  }) async {
    try {
      log('[PoseRepository] Creating pose in Firestore...');

      // Ensure we have an id
      final String id = pose.id.isNotEmpty ? pose.id : const Uuid().v4();
      final now = DateTime.now();

      final poseToSave = pose.copyWith(
        id: id,
        createdAt: pose.createdAt,
        updatedAt: now,
      );

      await _firestore
          .collection('poses')
          .doc(id)
          .set(poseToSave.toMap());

      log('[PoseRepository] Pose created with id: $id');
      return poseToSave;
    } catch (e, st) {
      log('[PoseRepository] Error creating pose: $e', stackTrace: st);
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