import 'package:frontend/data/datasources/pose_local_data.dart';
import 'package:frontend/data/datasources/pose_remote_data.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/constants.dart';


class PoseRepository {
  final PoseLocalDataSource localDataSrc;
  final PoseRemoteDataSource remoteDataSrc;

  PoseRepository({
    required this.localDataSrc,
    required this.remoteDataSrc,
  });

  PoseEntity _poseModelToEntity(PoseModel poseModel) {
    return PoseEntity(
      id: poseModel.id,
      name: poseModel.name,
      description: poseModel.description,
      cues: poseModel.cues,
      apparatus: poseModel.apparatus,
      level: poseModel.level,
      createdBy: poseModel.createdBy,
      updatedBy: poseModel.updatedBy,
      createdAt: poseModel.createdAt,
      updatedAt: poseModel.updatedAt,
      isSynced: poseModel.isSynced,
      primaryImageId: poseModel.primaryImageId,
      primaryImageUrl: poseModel.primaryImageUrl,
    );
  }

  List<PoseEntity> _poseModelsToEntities(List<PoseModel> models) {
    return models.map((model) => _poseModelToEntity(model)).toList();
  }

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
      final poseModel = await remoteDataSrc.createPose(
        name: name,
        description: description,
        cues: cues,
        apparatus: apparatus,
        level: level,
        primaryImageId: primaryImageId,
        token: token,
        createdBy: createdBy,
      );
      await localDataSrc.insertPose(poseModel);
      return _poseModelToEntity(poseModel);
    } catch (e) {
      // TODO Handle other potential errors (e.g., local database issues)
      rethrow;
    }
  }

  /// Fetch all poses from local DB
  Future<List<PoseEntity>> getLocalPoses() async {
    print("Fetching PoseModels from Local Database");
    final poseModels = await localDataSrc.getPoses();
    print("Converting to Pose Models to Entities");
    return _poseModelsToEntities(poseModels);
  }

  // TODO get all poses - try to sync and if not possible, return local poses with note that its local only (or last synced time)

  /// Fetch all poses from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    final poseModels = await remoteDataSrc.fetchRemotePoses(token: token);
    await localDataSrc.insertPoses(poseModels);
  }


  /// Send unsynced local poses to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final unsynced = await localDataSrc.getUnsyncedPoses();
    if (unsynced.isEmpty) {
      return;
    }

    print("Retrieved unsynced poses from local");
    final success = await remoteDataSrc.syncPoses(
      token: token,
      poses: unsynced,
    );
    print("Synced poses to remote");

    if (success) {
      for (final pose in unsynced) {
        await localDataSrc.setSyncedStatus(pose.id, 1);
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
    final poseModel = poseEntityToModel(updatedPose);

    final updatedModel = await remoteDataSrc.updatePose(
      updatedPose: poseModel,
      token: token,
    );

    await localDataSrc.updatePose(updatedModel);
  }

  /// Delete locally
  Future<void> deletePose(String id) async {
    await localDataSrc.deletePose(id);
  }
}

// Mapping function (can be in the repository or as a static method)
PoseEntity poseModelToEntity(PoseModel model) {
  return PoseEntity(
    id: model.id,
    name: model.name,
    description: model.description,
    cues: model.cues,
    apparatus: model.apparatus,
    level: model.level,
    createdBy: model.createdBy,
    updatedBy: model.updatedBy,
    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
    isSynced: model.isSynced,
    primaryImageId: model.primaryImageId,
    primaryImageUrl: model.primaryImageUrl,
  );
}

PoseModel poseEntityToModel(PoseEntity entity) {
  return PoseModel(
    id: entity.id,
    name: entity.name,
    description: entity.description,
    cues: entity.cues,
    apparatus: entity.apparatus,
    level: entity.level,
    createdBy: entity.createdBy,
    updatedBy: entity.updatedBy,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    isSynced: entity.isSynced,
    primaryImageId: entity.primaryImageId,
    primaryImageUrl: entity.primaryImageUrl,
  );
}

