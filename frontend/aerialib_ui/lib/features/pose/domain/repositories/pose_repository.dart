import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/pose/domain/mappers/pose_mapper.dart';

import 'package:frontend/features/pose/data/datasources/pose/pose_local_data.dart';
import 'package:frontend/features/pose/data/datasources/pose/pose_remote_data.dart';


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

      // 1. Get a new document ref to generate an autoId
      final docRef = _firestore.collection('poses').doc();
      final id = docRef.id;
      final now = DateTime.now();

      // 2. Overwrite the id (and updatedAt) on the pose
      final poseToSave = pose.copyWith(
        id: id,
        updatedAt: now,
      );

      // 3. Save to Firestore
      await docRef.set(poseToSave.toMap());

      log('[PoseRepository] Pose created with id: $id');
      return poseToSave;
    } catch (e, st) {
      log('[PoseRepository] Error creating pose: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Fetch all poses from local DB
  Future<List<PoseEntity>> getAllPoses() async {
    try {
      log('[PoseRepository] Fetching poses from Firestore...');

      final query = await _firestore
          .collection('poses')
          .orderBy('displayName')
          .get();

      final poses = query.docs
          .map((doc) => PoseEntity.fromMap(doc.data()))
          .toList();

      log('[PoseRepository] Got ${poses.length} poses from Firestore');
      return poses;
    } catch (e, st) {
      log('[PoseRepository] getAllPoses error: $e', stackTrace: st);
      rethrow;
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