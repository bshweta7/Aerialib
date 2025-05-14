import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/repositories/pose_repository.dart';

part 'poses_state.dart';

class PosesCubit extends Cubit<PosesState> {
  final PoseRepository _poseRepository;
  bool _isSyncing = false;

  PosesCubit(this._poseRepository) : super(const PoseInitial());

  /// Crud ----------------------------
  /// Create a new pose
  Future<void> createNewPose({
    required String name,
    required String description,
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
      emit(const PoseLoading());

      final pose = await _poseRepository.createPose(
        name: name,
        description: description,
        teachingCues: teachingCues,
        safetyCues: safetyCues,
        progressions: progressions,
        apparatus: apparatus,
        level: level,
        primaryMediaId: primaryMediaId,
        primaryMediaPath: primaryMediaPath,
        token: token,
        createdBy: createdBy,
      );

      emit(AddNewPoseSuccess(pose));
    } catch (e) {
      print("Error creating pose: $e");
      emit(PoseError(e.toString()));
    }
  }

  /// cRud ----------------------------
  /// Fetch all poses (from local storage or remote if needed)
  Future<void> getAllPoses({required String token}) async {
    try {
      print('[PosesCubit] Fetching poses...');
      emit(const PoseLoading());

      List<PoseEntity> poses = await _poseRepository.getAllPoses();  // Fetch local poses
      print('[PosesCubit] Number of Poses Retrieved: ${poses.length}');
      emit(GetPosesSuccess(poses));

    } catch (e) {
      print('[PosesCubit] GetAllPoses failed: $e');
      emit(PoseError(e.toString()));
    }
  }

  /// Run a one-time sync of poses when network is available (sync the unsynced local poses with remote)
  Future<void> syncPoses({required String token}) async {
    if (_isSyncing) return;
    _isSyncing = true;

    print("[PosesCubit] Starting one-shot sync...");

    try {
      await _poseRepository.syncLocalToRemote(token);
      print('[PosesCubit] Synced local to remote.');

      await _poseRepository.syncRemoteToLocal(token);
      print('[PosesCubit] Synced remote to local.');

      final updatedPoses = await _poseRepository.getAllPoses();
      emit(GetPosesSuccess(updatedPoses));
    } catch (e) {
      print('[PosesCubit] Sync error: $e');
      emit(PoseError('[PosesCubit] Sync error: $e'));
    } finally {
      _isSyncing = false;
    }
  }

  /// crUd ----------------------------
  /// Update pose info (both local and remote)
  Future<void> updatePoseInfo({
    required PoseEntity updatedPose,
    required String token,
  }) async {
    try {
      emit(const PoseLoading());
      await _poseRepository.updatePose(
        updatedPose: updatedPose,
        token: token,
      );
      emit(UpdatePoseSuccess(updatedPose));
    } catch (e) {
      print(e.toString());
      emit(PoseError(e.toString()));
    }
  }

  /// cruD ----------------------------
  /// Delete a pose locally
  Future<void> deletePose(String poseId) async {
    try {
      emit(const PoseLoading());
      await _poseRepository.deletePose(poseId);
      emit(DeletePoseSuccess(poseId));
    } catch (e) {
      print('[PosesCubit] Deleting error: $e');
      emit(PoseError('[PosesCubit] Deleting error: $e'));
    }
  }

}


// TODO - If syncRemoteToLocal or syncLocalToRemote can fail (e.g., due to network issues), you might want to handle those errors more gracefully (maybe show a snackbar or a retry button) in the UI. We have an optional PoseError state to handle those errors.
// TODO - The syncPoses method has been modified to first sync local unsynced poses and then sync remote poses back to local. You might want to consider handling the case where network is unavailable or when some poses are not synced successfully.
// TODO see his next video on background plugin that syncs every 7 days.
