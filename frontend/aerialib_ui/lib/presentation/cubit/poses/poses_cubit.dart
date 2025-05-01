import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/repositories/pose_repository.dart';

// TODO note - maybe I shouldn't combine the mediaURL into this and instead call it separately - see what makes sense...
// TODO - If syncRemoteToLocal or syncLocalToRemote can fail (e.g., due to network issues), you might want to handle those errors more gracefully (maybe show a snackbar or a retry button) in the UI. We have an optional PoseError state to handle those errors.
// TODO - The syncPoses method has been modified to first sync local unsynced poses and then sync remote poses back to local. You might want to consider handling the case where network is unavailable or when some poses are not synced successfully.

part 'poses_state.dart';

class PosesCubit extends Cubit<PosesState> {
  final PoseRepository _poseRepository;

  PosesCubit(this._poseRepository) : super(const PoseInitial());

  /// Create a new pose
  Future<void> createNewPose({
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
      emit(const PoseLoading());
      PoseEntity pose = await _poseRepository.createPose(
        name: name,
        description: description,
        cues: cues,
        apparatus: apparatus,
        level: level,
        primaryImageId: primaryImageId,
        token: token,
        createdBy: createdBy,
      );
      emit(AddNewPoseSuccess(pose));
    } catch (e) {
      print(e.toString());
      emit(PoseError(e.toString()));
    }
  }

  /// Fetch all poses (from local storage or remote if needed)
  Future<void> getAllPoses({required String token}) async {
    try {
      print("Fetching poses...");
      emit(const PoseLoading());

      List<PoseEntity> poses = await _poseRepository.getAllPoses();  // Fetch local poses
      if (poses.isEmpty) {
        // If no local poses, sync from remote and retry
        print("No poses in local datasource, syncing from remote");
        await _poseRepository.syncRemoteToLocal(token);

        poses = await _poseRepository.getAllPoses();
      }

      print("Number of Poses Retrieved: ${poses.length}");
      emit(GetPosesSuccess(poses));

    } catch (e) {
      print("Cubit GetAllPoses failed");
      print(e.toString());
      emit(PoseError(e.toString()));
    }
  }

  /// Sync poses (sync unsynced local poses with remote)
  Future<void> syncPoses(String token) async {
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi) || data.contains(ConnectivityResult.ethernet)) { // TODO add other options, possibly move to connectivity_service.dart
        print("Wifi available.");
        try {
          print("Syncing local to remote");
          await _poseRepository.syncLocalToRemote(token);

          print("Syncing remote to local");
          await _poseRepository.syncRemoteToLocal(token);

        } catch (e) {
          print("Sync error: $e");
          // Optional: emit a sync error state if needed
          emit(PoseError("Sync error: $e"));
        }

      } else {
        print("No wifi available");
      }
    });
  }

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
}



// TODO see his next video on background plugin that syncs every 7 days.
