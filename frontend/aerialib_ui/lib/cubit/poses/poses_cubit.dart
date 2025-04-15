import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/data/datasources/pose_remote_data.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/data/datasources/pose_local_data.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/data/models/pose_model.dart';
import '../../repositories/pose/pose_repository.dart';


// TODO note - maybe i shouldn't combine the mediaURL into this and instead call it separately - see what makes sense...

part 'poses_state.dart';

class PosesCubit extends Cubit<PosesState>{
  final PoseRepository _poseRepo;

  PosesCubit({required PoseRepository poseRepo})
      : _poseRepo = poseRepo,
        super(PoseInitial());

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
      final poseModel = await _poseRepo.createPose(
        name: name,
        description: description,
        cues: cues,
        apparatus: apparatus,
        level: level,
        primaryImageId: primaryImageId,
        token: token,
        createdBy: createdBy,
      );
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
      final poses = await _poseRepo.getAllPoses(token);
      emit(GetPosesSuccess(poses));
    } catch (e) {
      print(e.toString());
      emit(PoseError(e.toString()));
    }
  }

  Future<void> syncPoses(String token) async {
    try {
      await _poseRepo.syncIfNeeded(token);
    } catch (e) {
      print("Sync error: $e");
      // Optional: emit a sync error state if needed
    }
  }

  Future<void> updatePoseInfo({
    required PoseModel updatedPose,
    required String token,
  }) async {
    try {
      emit(PoseLoading());
      final poseModel = await _poseRepo.updatePose(
        updatedPose: updatedPose,
        token: token,
      );
      emit(UpdatePoseSuccess(poseModel)); // Emit success state
    } catch (e) {
      print(e.toString());
      emit(PoseError(e.toString()));
    }
  }
}

// TODO see his next video on background plugin that syncs every 7 days.
