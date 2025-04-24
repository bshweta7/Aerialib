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
    required String description,
    required String cues,
    required String apparatus,
    required int level,
    required String primaryImageId,
    required String token,
    required String createdBy,
  }) async {
    try {
      final poseModel = await remoteDataSource.createPose(
        name: name,
        description: description,
        cues: cues,
        apparatus: apparatus,
        level: level,
        primaryImageId: primaryImageId,
        token: token,
        createdBy: createdBy,
      );
      await localDataSource.insertPose(poseModel);
      return PoseMapper.poseModelToEntity(poseModel);
    } catch (e) {
      // TODO Handle other potential errors (e.g., local database issues)
      rethrow;
    }
  }

  /// Fetch all poses from local DB
  Future<List<PoseEntity>> getLocalPoses() async {
    print("Fetching PoseModels from Local Database");
    final poseModels = await localDataSource.getPoses();
    print("Converting to Pose Models to Entities");
    return PoseMapper.poseModelsToEntities(poseModels);
  }

  // TODO get all poses - try to sync and if not possible, return local poses with note that its local only (or last synced time)

  /// Fetch all poses from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    final poseModels = await remoteDataSource.fetchRemotePoses(token: token);
    await localDataSource.insertPoses(poseModels);
  }


  /// Send unsynced local poses to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<PoseModel> unsynced = await localDataSource.getUnsyncedPoses();
    if (unsynced.isEmpty) {
      return;
    }

    print("Retrieved unsynced poses from local");
    final success = await remoteDataSource.syncPoses(
      token: token,
      poses: unsynced,
    );
    print("Synced poses to remote");

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
    final poseModel = PoseMapper.poseEntityToModel(updatedPose);

    final updatedModel = await remoteDataSource.updatePose(
      updatedPose: poseModel,
      token: token,
    );

    await localDataSource.updatePose(updatedModel);
  }

  /// Delete locally
  Future<void> deletePose(String id) async {
    await localDataSource.deletePose(id);
  }
}
