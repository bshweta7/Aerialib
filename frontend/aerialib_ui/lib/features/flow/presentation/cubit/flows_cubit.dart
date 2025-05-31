import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/flow/domain/entities/flow_pose_entity.dart';

import 'package:frontend/features/flow/domain/repositories/flow_repository.dart';
import 'package:frontend/features/flow/domain/repositories/flow_pose_repository.dart';

part 'flows_state.dart';

class FlowsCubit extends Cubit<FlowsState> {
  final FlowRepository _flowRepository;
  final FlowPoseRepository _flowPoseRepository;
  bool _isSyncing = false;
  
  FlowsCubit(
      this._flowRepository,
      this._flowPoseRepository,
      ) : super(const FlowInitial());

  /// Crud ----------------------------
  /// Create a new flow (metadata only)
  Future<FlowsState> createNewFlow({
    required String name,
    String? description,
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

      log("[FlowsCubit] Created Flow ");

      final successState = AddNewFlowSuccess(flow);
      emit(successState);
      return successState;
    } catch (e) {
      log("[FlowsCubit] Error creating flow: $e");
      final errorState = FlowError(e.toString());
      emit(errorState);
      return errorState;
    }
  }

  /// cRud ----------------------------
  /// Fetch all flows (local first)
  Future<void> getAllFlows({required String token}) async {
    try {
      emit(const FlowLoading());

      // Step 1: Get flow details (no poses)
      List<FlowEntity> flows = await _flowRepository.getAllFlowDetails();

      // Step 2: Get all flow poses
      List<FlowPoseEntity> allFlowPoses = await _flowPoseRepository.getAllFlowPoses();

      // Step 3: Group poses by flowId
      final Map<String, List<FlowPoseEntity>> posesByFlowId = {};
      for (final pose in allFlowPoses) {
        posesByFlowId.putIfAbsent(pose.flowId, () => []).add(pose);
      }

      // Step 4: Attach poses to flows
      final List<FlowEntity> enrichedFlows = flows.map((flow) {
        return flow.copyWith(
          poses: posesByFlowId[flow.id] ?? [], // empty if no poses
        );
      }).toList();

      emit(GetFlowsSuccess(enrichedFlows));
    } catch (e) {
      log("[FlowsCubit] Error fetching flows: $e");
      emit(FlowError(e.toString()));
    }
  }

  /// Run a one-time sync of flows when network is available (sync the unsynced local flows with remote)
  Future<void> syncFlowDetails({required String token}) async {
    if (_isSyncing) return;
    _isSyncing = true;
    // log("[FlowsCubit] Starting one-shot sync of flow details...");

    try {
      log('[FlowsCubit] Syncing flow details local to remote...');
      await _flowRepository.syncLocalToRemote(token);

      log('[FlowsCubit] Syncing flow details remote to local...');
      await _flowRepository.syncRemoteToLocal(token);

    } catch (e) {
      log('[FlowsCubit] Sync error for flow details: $e');
      emit(FlowError('[FlowsCubit] Sync error for flow details: $e'));

    } finally {
      _isSyncing = false;

    }
  }

  /// Run a one-time sync of flows when network is available (sync the unsynced local flows with remote)
  Future<void> syncFlowPoses({required String token}) async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      log('[FlowsCubit] Syncing flow poses local to remote...');
      await _flowPoseRepository.syncLocalToRemote(token);

      log('[FlowsCubit] Syncing flow poses remote to local...');
      await _flowPoseRepository.syncRemoteToLocal(token);

    } catch (e) {
      log('[FlowsCubit] Sync error for flow poses: $e');
      emit(FlowError('[FlowsCubit] Sync error for flow poses: $e'));

    } finally {
      _isSyncing = false;
    }
  }

  Future<void> syncFlows({required String token}) async {
    log("[FlowsCubit] Starting one-shot sync of flows...");
    await syncFlowDetails(token: token);
    await syncFlowPoses(token: token);

    final updatedFlows = await _flowRepository.getAllFlowDetails();
    log("[FlowsCubit] Flows sync complete.");

    emit(GetFlowsSuccess(updatedFlows));
  }


  /// crUd ----------------------------
  /// Start editing an existing flow (initialize EditFlowState)
  Future<void> startEditingFlow(FlowEntity flow) async {
    try {
      emit(EditFlowState(flow: flow));

      // Then fetch available poses
      log("[FlowsCubit] Fetching all available poses...");
      final poses = await _flowPoseRepository.getAllLocalPoses();

      final currentState = state;
      log("[FlowsCubit] Emitting new EditFlowState with ${poses.length} available poses");

      if (currentState is EditFlowState) {
        emit(currentState.copyWith(availablePoses: poses));
      }

    } catch (e) {
      log("[FlowsCubit] Error initializing editing flow: $e");
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
      log("[FlowsCubit] ${e.toString()}");
      emit(FlowError(e.toString()));
    }
  }

  /// Sets flow.poses to the new set of poses
  void updateFlowPoses(List<FlowPoseEntity> newPoses) {
    log("[FlowsCubit] Updating flow poses... ");

    if (state is! EditFlowState) {
      log("[FlowsCubit] State is not EditFlowState, returning without update...");
      return;
    }
    final currentState = state as EditFlowState;

    // 🔍 log BEFORE
    // log("[FlowsCubit] Existing poses in flow BEFORE update:");
    // log(currentState.flow);
    // for (final p in currentState.flow.poses) {
    //   log("↪️ ${p.id}, flowId: ${p.flowId}, poseId: ${p.pose.id}, order: ${p.poseOrder}");
    // }

    final updatedFlow = currentState.flow.copyWith(poses: newPoses);


    // 🔍 log AFTER
    // log("[FlowsCubit] Poses to update TO:");
    // log(currentState.flow);
    // for (final p in currentState.flow.poses) {
    //   log("↪️ ${p.id}, flowId: ${p.flowId}, poseId: ${p.pose.id}, order: ${p.poseOrder}");
    // }

    log("[FlowsCubit] Updated flow cubit with new poses.");
    emit(currentState.copyWith(flow: updatedFlow));
  }

  /// cruD ----------------------------
  /// Delete local flows (e.g. logging out)
  Future<void> clearLocalFlows() async {
    try {
      final allFlows = await _flowRepository.getAllFlowDetails();

      for (final flow in allFlows) {
        await _flowRepository.deleteFlowLocally(flow.id);
      }

      emit(const FlowInitial());
    } catch (e) {
      log("[FlowsCubit] Error clearing local flows: $e");
      emit(FlowError("Failed to clear local flows: $e"));
    }
  }

  /// Delete flow locally and in remote db
  Future<void> deleteFlow({
    required String flowId,
    required String token
  }) async {
    try {
      log("[FlowsCubit] Deleting flow...");
      await _flowRepository.deleteFlow(flowId, token);
    } catch (e) {
      log("[FlowsCubit] Error deleting flow: $e");
      emit(FlowError("Failed to delete flow: $e"));
    }
  }

  /// Save the flows poses (local + remote)
  Future<void> saveFlowPoses({required String token}) async {
    // log("[FlowCubit] State is $state");
    if (state is! EditFlowState) {
      log("[FlowsCubit] State is not EditFlowState, returning without update...");
      return;
    }
    final currentState = state as EditFlowState;

    emit(currentState.copyWith(isSaving: true));

    try {
      // log("[FlowsCubit] Updating flow details...");
      // await _flowRepository.updateFlow(
      //   updatedFlow: currentState.flow,
      //   token: token,
      // );
      log("[FlowsCubit] Deleting all flow poses in flow ${currentState.flow.name}, ${currentState.flow.id}");
      await _flowPoseRepository.deleteAllFlowPosesInFlow(currentState.flow.id);

      log("[FlowsCubit] Inserting updated poses into flow...");
      await _flowPoseRepository.insertFlowPoses(currentState.flow.poses);

      log("[FlowPoseRepository] Syncing to remote data source...");
      await _flowPoseRepository.syncLocalToRemote(token);
      log("[FlowPoseRepository] Synced to remote successfully.");




      // log("[FlowsCubit] Updating flow poses in flow...");
      // await _flowPoseRepository.replaceFlowPosesInFlow(
      //   flowId: currentState.flow.id,
      //   newPoses: currentState.flow.poses,
      //   token: token,
      // );
      emit(currentState.copyWith(isSaving: false, saveSuccess: true));
    } catch (e) {
      log("[FlowsCubit] Error saving flow: $e");
      emit(currentState.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
        flow: currentState.flow,
      ));
    }
  }
}
