import 'package:frontend/data/datasources/pose_local_data.dart';
import 'package:frontend/data/datasources/pose_remote_data.dart';
import 'package:frontend/data/models/pose_model.dart';


class PoseRepository {
  final PoseLocalDataSource localRepo;
  final PoseRemoteDataSource remoteRepo;

  PoseRepository({
    required this.localRepo,
    required this.remoteRepo,
  });

  /// Create a new pose (tries remote first, fallback to local if offline)
  Future<PoseModel> createPose({
    required String name,
    required String description,
    required String cues,
    required String apparatus,
    required int level,
    required String primaryImageId,
    required String token,
    required String createdBy,
  }) async {
    final pose = await remoteRepo.createPose(
      name: name,
      description: description,
      cues: cues,
      apparatus: apparatus,
      level: level,
      primaryImageId: primaryImageId,
      token: token,
      createdBy: createdBy,
    );

    await localRepo.insertPose(pose);
    return pose;
  }

  /// Fetch all poses from local DB
  Future<List<PoseModel>> getLocalPoses() {
    return localRepo.getPoses();
  }

  /// Fetch all poses from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    final poses = await remoteRepo.fetchRemotePoses(token: token);
    await localRepo.insertPoses(poses);
  }


  /// Send unsynced local poses to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final unsynced = await localRepo.getUnsyncedPoses();
    final success = await remoteRepo.syncPoses(token: token, poses: unsynced);

    if (success) {
      for (final pose in unsynced) {
        await localRepo.setSyncedStatus(pose.id, 1);
      }
    }
  }


  /// Full sync (both directions)
  Future<void> fullSync(String token) async {
    await syncLocalToRemote(token);
    await syncRemoteToLocal(token);
  }


  /// Update a pose remotely and locally
  Future<void> updatePose({
    required PoseModel pose,
    required String token,
  }) async {
    final updated = await remoteRepo.updatePose(
      updatedPose: pose,
      token: token,
    );
    await localRepo.updatePose(updated);
  }


  /// Delete locally (optional addition)
  Future<void> deletePose(String id) async {
    await localRepo.deletePose(id);
  }
}
