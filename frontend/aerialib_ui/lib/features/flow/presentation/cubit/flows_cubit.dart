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

  /// Create a new flow (metadata only)
  Future<void> createNewFlow({
    required FlowEntity flow,
    required String token,
  }) async {
    try {
      emit(const FlowLoading());

      final createdFlow = await _flowRepository.createFlow(
        flow: flow,
        token: token,
      );

      final allFlows = await _flowRepository.getAllFlowDetails();
      emit(GetFlowsSuccess(allFlows));

    } catch (e) {

      log("[FlowsCubit] Error creating flow: $e");
      emit(FlowError(e.toString()));
    }
  }

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
          flowPoses: posesByFlowId[flow.id] ?? [], // empty if no poses
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

      // final allPoses = await _flowRepository.getAllFlowDetails();
      // emit(GetPosesSuccess(allPoses));
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

    final updatedFlow = currentState.flow.copyWith(flowPoses: newPoses);


    // 🔍 log AFTER
    // log("[FlowsCubit] Poses to update TO:");
    // log(currentState.flow);
    // for (final p in currentState.flow.poses) {
    //   log("↪️ ${p.id}, flowId: ${p.flowId}, poseId: ${p.pose.id}, order: ${p.poseOrder}");
    // }

    log("[FlowsCubit] Updated flow cubit with new poses.");
    emit(currentState.copyWith(flow: updatedFlow));
  }


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


  /// Save the flows poses (local + remote)
  Future<void> saveFlowPoses({required String token}) async {
    if (state is! EditFlowState) return;

    final currentState = state as EditFlowState;
    final flowId = currentState.flow.id;
    final flowPoses = currentState.flow.flowPoses;

    try {
      log("[FlowsCubit] Deleting existing flow poses from local and remote...");
      await _flowPoseRepository.deleteAllFlowPosesInFlow(
        flowId: flowId,
        token: token
      );

      log("[FlowsCubit] Creating new flow poses locally and remotely...");
      await _flowPoseRepository.createFlowPoses(
        flowPoses: flowPoses,
        token: token,
      );

      log("[FlowsCubit] Refreshing flow list...");
      await getAllFlows(token: token);
    } catch (e) {
      log("[FlowsCubit] Error while saving flow poses: $e");
      emit(const FlowError("Failed to save updated flow poses"));
    }
  }


  /// Delete local flows (e.g. logging out)
  Future<void> clearLocalFlows() async { // TODO verify this function
    try {
      final allFlows = await _flowRepository.getAllFlowDetails();

      for (final flow in allFlows) {
        await _flowRepository.deleteFlowLocally(flowId: flow.id);
      }

      emit(const FlowInitial());
    } catch (e) {
      log("[FlowsCubit] Error clearing local flows: $e");
      emit(FlowError("Failed to clear local flows: $e"));
    }
  }

  /// Delete flow locally and in remote db
  Future<void> deleteFlow({ // TODO verify this function
    required String flowId,
    required String token
  }) async {
    try {
      log("[FlowsCubit] Deleting flow...");
      await _flowRepository.deleteFlow(id: flowId, token: token);
    } catch (e) {
      log("[FlowsCubit] Error deleting flow: $e");
      emit(FlowError("Failed to delete flow: $e"));
    }
  }


}
