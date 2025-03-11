
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/poses/repository/pose_remote_repository.dart';
import 'package:frontend/models/pose_model.dart';

import '../repository/pose_local_repository.dart';

part 'poses_state.dart';

class PosesCubit extends Cubit<PosesState>{
  PosesCubit() : super(PoseInitial());
  final poseRemoteRepository = PoseRemoteRepository();
  final poseLocalRepository = PoseLocalRepository();

  Future<void> createNewPose({
    required String title,
    required String description,
    required Color color,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      emit(PoseLoading());
      final poseModel = await poseRemoteRepository.createPose(
          title: title,
          description: description,
          hexColor: rgbToHex(color),
          token: token,
          dueAt: dueAt
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
}