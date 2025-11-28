import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/pose/domain/repositories/pose_repository.dart';

part 'poses_state.dart';

class PosesCubit extends Cubit<PosesState> {
  final PoseRepository _poseRepository;
  bool _isSyncing = false;

  PosesCubit(this._poseRepository) : super(const PoseInitial());

  List<PoseEntity> get poses {
    final currentState = state;
    if (currentState is GetPosesSuccess) {
      return currentState.poses;
    }
    return [];
  }

  /// Create a new pose
  Future<void> createNewPose({
    required PoseEntity pose,
  }) async {
    try {
      emit(const PoseLoading());

      final createdPose = await _poseRepository.createPose(
        pose: pose,
      );

      // TODO - see if commenting this out breaks anything (router)
      //  emit(AddNewPoseSuccess(createdPose));
      final allPoses = await _poseRepository.getAllPoses();
      emit(GetPosesSuccess(allPoses));

    } catch (e) {
      log("[PoseCubit] Error creating pose: $e");
      emit(PoseError(e.toString()));
    }
  }

  /// Fetch all poses (from local storage or remote if needed)
  Future<void> getAllPoses({required String token}) async {
    try {
      log('[PosesCubit] Fetching poses...');
      emit(const PoseLoading());

      List<PoseEntity> allPoses = await _poseRepository.getAllPoses();  // Fetch local poses
      log('[PosesCubit] Number of Poses Retrieved: ${allPoses.length}');
      emit(GetPosesSuccess(allPoses));

    } catch (e) {
      log('[PosesCubit] GetAllPoses failed: $e');
      emit(PoseError(e.toString()));
    }
  }

  /// Run a one-time sync of poses when network is available (sync the unsynced local poses with remote)
  Future<void> syncPoses({required String token}) async {
    if (_isSyncing) return;
    _isSyncing = true;

    // log("[PosesCubit] Starting one-shot sync...");

    try {
      await _poseRepository.syncLocalToRemote(token);
      // log('[PosesCubit] Synced local to remote.');

      await _poseRepository.syncRemoteToLocal(token);
      // log('[PosesCubit] Synced remote to local.');

      final allPoses = await _poseRepository.getAllPoses();
      emit(GetPosesSuccess(allPoses));
    } catch (e) {
      log('[PosesCubit] Sync error: $e');
      emit(PoseError('[PosesCubit] Sync error: $e'));
    } finally {
      _isSyncing = false;
    }
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
      final allPoses = await _poseRepository.getAllPoses();
      emit(GetPosesSuccess(allPoses));

    } catch (e) {
      log(e.toString());
      emit(PoseError(e.toString()));
    }
  }

  /// Delete a pose
  Future<void> deletePose({
    required String poseId,
    required String token,
  }) async {
    try {
      emit(const PoseLoading());
      await _poseRepository.deletePoseRemote(id: poseId, token: token);
      emit(DeletePoseSuccess(poseId));

      final allPoses = await _poseRepository.getAllPoses();
      emit(GetPosesSuccess(allPoses));
    } catch (e) {
      log('[PosesCubit] Deleting error: $e');
      emit(PoseError('[PosesCubit] Deleting error: $e'));
    }
  }


  Future<void> refresh({required String token}) async {
    try {
      emit(const PoseLoading());
      final allPoses = await _poseRepository.getAllPoses();
      emit(GetPosesSuccess(allPoses));
    } catch (e) {
      emit(PoseError('Refresh error: ${e.toString()}'));
    }
  }

  Future<void> refreshLocalOnly() async {
    try {
      final allPoses = await _poseRepository.getAllPoses();
      emit(GetPosesSuccess(allPoses));
    } catch (e) {
      emit(PoseError('Local refresh error: ${e.toString()}'));
    }
  }

}


