import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/poses/repository/pose_remote_repository.dart';
import 'package:frontend/models/pose_model.dart';
import 'package:frontend/features/poses/repository/pose_local_repository.dart';

part 'poses_state.dart';

class PosesCubit extends Cubit<PosesState>{
  PosesCubit() : super(PoseInitial());
  final poseRemoteRepository = PoseRemoteRepository();
  final poseLocalRepository = PoseLocalRepository();

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
      emit(PoseLoading());
      final poseModel = await poseRemoteRepository.createPose(
        name: name,
        description: description,
        cues: cues,
        apparatus: apparatus,
        level: level,
        primaryImageId: primaryImageId,
        token: token,
        createdBy: createdBy,
      );
      await poseLocalRepository.insertPose(poseModel);

      emit(AddNewPoseSuccess(poseModel));
    } catch (e) {
      print(e.toString());
      emit(PoseError(e.toString()));
    }
  }

  Future<void> getAllPoses({required String token,
  }) async {
    try {
      emit(PoseLoading());
      final poses = await poseRemoteRepository.getPoses(token: token);

      emit(GetPosesSuccess(poses));

    } catch (e) {
      print(e.toString());
      emit(PoseError(e.toString()));
    }
  }

  Future<void> syncPoses(String token) async {
    // get all unsynced poses from our sqlite db
    final unsyncedPoses = await poseLocalRepository.getUnsyncedPoses();
    print(unsyncedPoses);
    if (unsyncedPoses.isEmpty) {
      return;
    }
    // talk to our postgresql db to add the new pose
    final isSynced = await poseRemoteRepository.syncPoses(
        token: token,
        poses: unsyncedPoses
    );
    // change the poses that were added to the db from 0 to 1
    if (isSynced) {
      print("Poses have been synced");
      for (final pose in unsyncedPoses) {
        poseLocalRepository.updateRowValue(pose.id, 1);
      }
    }
  }

  Future<void> updatePoseInfo({
    required PoseModel updatedPose,
    required String token,
  }) async {
    try {
      emit(PoseLoading());
      final poseModel = await poseRemoteRepository.updatePose(
        updatedPose: updatedPose,
        token: token,
      );
      await poseLocalRepository.updatePose(poseModel); // Update local repository

      emit(UpdatePoseSuccess(poseModel)); // Emit success state
    } catch (e) {
      print(e.toString());
      emit(PoseError(e.toString()));
    }
  }
}

// TODO see his next video on background plugin that syncs every 7 days.
