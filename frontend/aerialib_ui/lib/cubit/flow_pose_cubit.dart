import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/features/flows/repository/flow_pose_remote_repository.dart';
import 'package:frontend/features/flows/repository/flow_pose_local_repository.dart';

import 'package:frontend/models/flow_pose_model.dart';

part 'flow_pose_state.dart';

class FlowPoseCubit extends Cubit<FlowPoseState> {
  FlowPoseCubit() : super(FlowPoseInitial());
  final flowPoseLocalRepository = FlowPoseLocalRepository();
  final flowPoseRemoteRepository = FlowPoseRemoteRepository();

  Future<void> createNewFlowPose({
    required String flowId,
    required String poseId,
    required int order,
    required String transitionId,
    required String token,
  }) async {
    try {
      emit(FlowPoseLoading());
      final flowPoseModel = await flowPoseRemoteRepository.createFlowPose(
        flowId: flowId,
        poseId: poseId,
        order: order,
        transitionId: transitionId,
        token: token,
      );
      await flowPoseLocalRepository.insertFlowPose(flowPoseModel);

      emit(AddNewFlowPoseSuccess(flowPoseModel));
    } catch (e) {
      print(e.toString());
      emit(FlowPoseError(e.toString()));
    }
  }

  // TODO can make function that only gets flow poses from specified flowId (define a function in remote repo as well)
  Future<void> getAllFlowPoses({required String token,
  }) async {
    try {
      emit(FlowPoseLoading());
      final flowPoses = await flowPoseRemoteRepository.getFlowPoses(
          token: token); // TODO why is this getting from remote - double check that this works everywhere.
      emit(GetFlowPosesSuccess(flowPoses));
    } catch (e) {
      print(e.toString());
      emit(FlowPoseError(e.toString()));
    }
  }

  Future<void> syncFlowPoses(String token) async {
    // get all unsynced flowPoses from our sqlite db
    final unsyncedFlowPoses = await flowPoseLocalRepository
        .getUnsyncedFlowPoses();

    if (unsyncedFlowPoses.isEmpty) {
      return;
    }

    print("Unsynced flowPoses:");
    print(unsyncedFlowPoses);

    // talk to our postgresql db to add the new flowPose
    final isSynced = await flowPoseRemoteRepository.syncFlowPoses(
        token: token,
        flowPoses: unsyncedFlowPoses
    );
    // change the flowPoses that were added to the db from 0 to 1
    if (isSynced) {
      print("FlowPoses have been synced");
      for (final flowPose in unsyncedFlowPoses) {
        flowPoseLocalRepository.updateSyncedStatus(flowPose.id, 1);
      }
    }
  }

  Future<void> updateFlowPoseInfo({
    required FlowPoseModel updatedFlowPose,
    required String token,
  }) async {
    try {
      emit(FlowPoseLoading());
      final flowPoseModel = await flowPoseRemoteRepository.updateFlowPose(
        updatedFlowPose: updatedFlowPose,
        token: token,
      );
      await flowPoseLocalRepository.updateFlowPose(
          flowPoseModel); // Update local repository

      emit(UpdateFlowPoseSuccess(flowPoseModel)); // Emit success state
    } catch (e) {
      print(e.toString());
      emit(FlowPoseError(e.toString()));
    }
  }
}