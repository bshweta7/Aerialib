import 'package:frontend/data/datasources/poses/pose_local_data.dart';
import 'package:frontend/data/datasources/poses/pose_remote_data.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/domain/entities/pose_entity.dart';

import '../mappers/pose_mapper.dart';

class PoseRepository {
  final PoseLocalDataSource localDataSource;
  final PoseRemoteDataSource remoteDataSource;

  PoseRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Create a new pose (tries remote first, fallback to local if offline)
  Future<PoseEntity> createPose({
    required String name,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    required String apparatus,
    required double level,
    required String primaryMediaId,
    required String primaryMediaPath,
    required String token,
    required String createdBy,
  }) async {
    try {
      print('[PoseRepository] Creating pose remotely...');

      // Step 1: Create pose on backend
      final poseModel = await remoteDataSource.createPose(
        name: name,
        description: description,
        teachingCues: teachingCues,
        safetyCues: safetyCues,
        progressions: progressions,
        apparatus: apparatus,
        level: level,
        primaryMediaId: primaryMediaId,
        primaryMediaPath: primaryMediaPath,
        createdBy: createdBy,
        token: token,
      );

      print('[PoseRepository] Remote pose created with ID: ${poseModel.id}');

      // Step 2: Insert into local DB
      await localDataSource.insertPose(poseModel);
      print('[PoseRepository] Pose inserted into local database.');

      // Step 3: Return mapped PoseEntity
      final entity = PoseMapper.modelToEntity(poseModel);
      print('[PoseRepository] Mapped PoseModel to PoseEntity: ${entity.id}');
      return entity;

    } catch (e) {
      print('[PoseRepository] Error creating pose: $e');
      rethrow;
    }
  }


  /// Fetch all poses from local DB
  Future<List<PoseEntity>> getAllPoses() async {
    print('[PosesRepository] Fetching PoseModels from local database... ');

    final poseModels = await localDataSource.getAllPoses();

    // print('[PosesRepository] Converting models to entities');
    final poseEntitiesList = PoseMapper.modelsToEntities(poseModels);
    print('[PosesRepository] Got ${poseModels.length} pose entities');
    // print('[PosesRepository] Conversion complete');

    return poseEntitiesList;
  }

  // TODO get all poses - try to sync and if not possible, return local poses with note that its local only (or last synced time)

  /// Fetch all poses from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    final poseModels = await remoteDataSource.fetchRemotePoses(token: token);
    // print(poseModels);
    await localDataSource.insertPoses(poseModels);
  }


  /// Send unsynced local poses to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<PoseModel> unsynced = await localDataSource.getUnsyncedPoses();
    if (unsynced.isEmpty) {
      return;
    }

    print("[PoseRepository] Retrieved unsynced poses from local");
    final success = await remoteDataSource.syncPoses(
      token: token,
      poses: unsynced,
    );
    print("[PoseRepository] Synced poses to remote");

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

    print("[PoseRepository] Updating pose remotely...");
    final updatedModel = await remoteDataSource.updatePose(
      updatedPose: poseModel,
      token: token,
    );

    print("[PoseRepository] Updating pose locally...");
    final syncedModel = updatedModel.copyWith(isSynced: 1);
    await localDataSource.updatePose(syncedModel);
  }

  /// Delete locally
  Future<void> deletePose(String id) async {
    await localDataSource.deletePose(id);
  }
}