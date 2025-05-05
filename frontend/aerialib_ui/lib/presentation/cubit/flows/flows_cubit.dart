import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/entities/flow_pose_entity.dart';

import 'package:frontend/domain/repositories/flow_repository.dart';
import 'package:frontend/domain/repositories/flow_pose_repository.dart';

part 'flows_state.dart';

class FlowsCubit extends Cubit<FlowsState> {
  final FlowRepository _flowRepository;
  final FlowPoseRepository _flowPoseRepository;
  bool _isSyncing = false;
  
  FlowsCubit(
      this._flowRepository,
      this._flowPoseRepository,
      ) : super(const FlowInitial());

  /// Fetch all flows (local first)
  Future<void> getAllFlows({required String token}) async {
    try {
      emit(const FlowLoading());
      List<FlowEntity> flows = await _flowRepository.getAllFlowDetails();
      if (flows.isEmpty) {
        await _flowRepository.syncRemoteToLocal(token);
        flows = await _flowRepository.getAllFlowDetails();
      }
      emit(GetFlowsSuccess(flows));
    } catch (e) {
      print("Error fetching flows: $e");
      emit(FlowError(e.toString()));
    }
  }

  /// Run a one-time sync of flows when network is available (sync the unsynced local flows with remote)
  Future<void> syncFlowDetails(String token) async {
    if (_isSyncing) return;
    _isSyncing = true;

    print("[FlowsCubit] Starting one-shot sync of flow details...");

    try {
      await _flowRepository.syncLocalToRemote(token);
      print('[FlowsCubit] Synced local to remote.');

      await _flowRepository.syncRemoteToLocal(token);
      print('[FlowsCubit] Synced remote to local.');

      final updatedFlows = await _flowRepository.getAllFlowDetails();
      emit(GetFlowsSuccess(updatedFlows));
    } catch (e) {
      print('[FlowsCubit] Sync error: $e');
      emit(FlowError('[FlowsCubit] Sync error: $e'));
    } finally {
      _isSyncing = false;
    }
  }

  /// Run a one-time sync of flows when network is available (sync the unsynced local flows with remote)
  Future<void> syncFlowPoses(String token) async {
    if (_isSyncing) return;
    _isSyncing = true;

    print("[FlowsCubit] Starting one-shot sync of flow poses...");

    try {
      await _flowPoseRepository.syncLocalToRemote(token);
      print('[FlowsCubit] Synced local to remote.');

      await _flowPoseRepository.syncRemoteToLocal(token);
      print('[FlowsCubit] Synced remote to local.');

      // final updatedFlows = await _flowPoseRepository.getAllFlowPoses();
      // emit(GetFlowsSuccess(updatedFlows));
    } catch (e) {
      print('[FlowsCubit] Sync error: $e');
      emit(FlowError('[FlowsCubit] Sync error: $e'));
    } finally {
      _isSyncing = false;
    }
  }


  /// Create a new flow (metadata only)
  Future<void> createNewFlow({
    required String name,
    required String description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    required String apparatus,
    required double level,
    required String thumbnailImageId,
    required String thumbnailImagePath,
    required String createdBy,
    required String token,
  }) async {
    try {
      emit(const FlowLoading());

      final flow = await _flowRepository.createFlow(
        name: name,
        description: description,
        teachingCues: teachingCues,
        safetyCues: safetyCues,
        progressions: progressions,
        apparatus: apparatus,
        level: level,
        thumbnailImageId: thumbnailImageId,
        thumbnailImagePath: thumbnailImagePath,
        createdBy: createdBy,
        token: token,
      );

      emit(AddNewFlowSuccess(flow));
    } catch (e) {
      print("Error creating flow: $e");
      emit(FlowError(e.toString()));
    }
  }

  /// Start editing an existing flow (initialize EditFlowState)
  Future<void> startEditingFlow(FlowEntity flow) async {
    try {
      emit(EditFlowState(flow: flow));

      // Then fetch available poses
      print("Fetching all available poses...");
      final poses = await _flowPoseRepository.getAllLocalPoses();

      final currentState = state;
      print("Emitting new EditFlowState with ${poses.length} available poses");

      if (currentState is EditFlowState) {
        emit(currentState.copyWith(availablePoses: poses));
      }

    } catch (e) {
      print("Error initializing editing flow: $e");
      emit(FlowError(e.toString()));
    }
  }

  // /// Add a pose to the current flow
  // void addPoseToFlow(PoseEntity pose) {
  //   if (state is! EditFlowState) return;
  //   final currentState = state as EditFlowState;
  //
  //   final newPose = FlowPoseEntity(
  //     id: const Uuid().v6(),
  //     flowId: currentState.flow.id,
  //     pose: pose,
  //     poseOrder: currentState.flow.poses.length,
  //   );
  //
  //   final updatedFlow = currentState.flow.copyWith(
  //     poses: [...currentState.flow.poses, newPose],
  //   );
  //
  //   emit(currentState.copyWith(flow: updatedFlow));
  // }

  /// Update flow info (both local and remote)
  Future<void> saveFlowDetails({
    required FlowEntity updatedFlow,
    required String token,
  }) async {
    try {
      emit(const FlowLoading());
      await _flowRepository.updateFlow(
        updatedFlow: updatedFlow,
        token: token,
      );
      emit(UpdateFlowSuccess(updatedFlow));
    } catch (e) {
      print(e.toString());
      emit(FlowError(e.toString()));
    }
  }

  /// Sets flow.poses to the new set of poses
  void updateFlowPoses(List<FlowPoseEntity> newPoses) {
    if (state is! EditFlowState) return;
    final currentState = state as EditFlowState;
    final updatedFlow = currentState.flow.copyWith(poses: newPoses);
    print("[FlowsCubit] Updated flow with new poses");

    emit(currentState.copyWith(flow: updatedFlow));
  }

  /// Save the flow and its poses (local + remote)
  Future<void> saveFlow(String token) async {
    if (state is! EditFlowState) return;
    final currentState = state as EditFlowState;

    emit(currentState.copyWith(isSaving: true));

    try {
      // print("[FlowsCubit] Updating flow details...");
      // await _flowRepository.updateFlow(
      //   updatedFlow: currentState.flow,
      //   token: token,
      // );
      print("[FlowsCubit] Updating flow poses in flow...");
      await _flowPoseRepository.replaceFlowPosesInFlow(
        flowId: currentState.flow.id,
        newPoses: currentState.flow.poses,
        token: token,
      );
      emit(currentState.copyWith(isSaving: false, saveSuccess: true));
    } catch (e) {
      print("[FlowsCubit] Error saving flow: $e");
      emit(currentState.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }
}
