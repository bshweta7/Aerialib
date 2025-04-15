import 'package:frontend/repositories/pose/pose_local_repository.dart';
import 'package:frontend/repositories/pose/pose_remote_repository.dart';
import 'package:frontend/models/pose_model.dart';


class PoseRepository {
  final PoseLocalRepository _localRepo;
  final PoseRemoteRepository _remoteRepo;

  PoseRepository({
    required PoseLocalRepository localRepo,
    required PoseRemoteRepository remoteRepo,
  })  : _localRepo = localRepo,
        _remoteRepo = remoteRepo;

  Future<List<PoseModel>> getAllPoses(String token) async {
    try {
      final remotePoses = await _remoteRepo.getPoses(token: token);
      return remotePoses;
    } catch (_) {
      return _localRepo.getPoses();
    }
  }

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
    final newPose = await _remoteRepo.createPose(
      name: name,
      description: description,
      cues: cues,
      apparatus: apparatus,
      level: level,
      primaryImageId: primaryImageId,
      token: token,
      createdBy: createdBy,
    );

    await _localRepo.insertPose(newPose); // always keep local in sync
    return newPose;
  }

  Future<PoseModel> updatePose({
    required PoseModel updatedPose,
    required String token,
  }) async {
    final pose = await _remoteRepo.updatePose(updatedPose: updatedPose, token: token);
    await _localRepo.updatePose(pose);
    return pose;
  }

  Future<void> syncIfNeeded(String token) async {
    final unsyncedPoses = await _localRepo.getUnsyncedPoses();
    if (unsyncedPoses.isNotEmpty) {
      final success = await _remoteRepo.syncPoses(token: token, poses: unsyncedPoses);
      if (success) {
        for (final pose in unsyncedPoses) {
          await _localRepo.updateSyncedStatus(pose.id, 1); // mark as synced
        }
      }
    }
  }
}
