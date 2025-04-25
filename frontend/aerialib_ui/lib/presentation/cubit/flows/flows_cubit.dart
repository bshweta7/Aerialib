import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/repositories/flow_repository.dart';
import 'package:frontend/domain/repositories/flow_pose_repository.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/flow_pose_entity.dart';

part 'flows_state.dart';

class FlowsCubit extends Cubit<FlowsState> {
  final FlowRepository _flowRepository;
  final FlowPoseRepository _flowPoseRepository;

  FlowsCubit(
      this._flowRepository,
      this._flowPoseRepository,
      ) : super(const FlowInitial());

  /// Fetch all flows (local first)
  Future<void> getAllFlows({required String token}) async {
    try {
      emit(const FlowLoading());
      List<FlowEntity> flows = await _flowRepository.getLocalFlows();
      if (flows.isEmpty) {
        await _flowRepository.syncRemoteToLocal(token);
        flows = await _flowRepository.getLocalFlows();
      }
      emit(GetFlowsSuccess(flows));
    } catch (e) {
      print("Error fetching flows: $e");
      emit(FlowError(e.toString()));
    }
  }

  /// Create a new flow (metadata only)
  Future<void> createNewFlow({
    required String name,
    required String description,
    required String apparatus,
    required String createdBy,
    required String token,
  }) async {
    try {
      emit(const FlowLoading());
      final flow = await _flowRepository.createFlow(
        name: name,
        description: description,
        apparatus: apparatus,
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
    } catch (e) {
      print("Error initializing editing flow: $e");
      emit(FlowError(e.toString()));
    }
  }

  /// Add a pose to the current flow
  void addPoseToFlow(PoseEntity pose) {
    if (state is! EditFlowState) return;
    final currentState = state as EditFlowState;

    final newPose = FlowPoseEntity(
      id: const Uuid().v6(),
      flowId: currentState.flow.id,
      pose: pose,
      order: currentState.flow.poses.length,
    );

    final updatedFlow = currentState.flow.copyWith(
      poses: [...currentState.flow.poses, newPose],
    );

    emit(currentState.copyWith(flow: updatedFlow));
  }

  /// Reorder poses in the flow
  void reorderFlowPoses(List<FlowPoseEntity> reorderedPoses) {
    if (state is! EditFlowState) return;
    final currentState = state as EditFlowState;

    final updatedPoses = reorderedPoses.asMap().entries.map((entry) {
      final index = entry.key;
      final pose = entry.value.copyWith(order: index);
      return pose;
    }).toList();

    final updatedFlow = currentState.flow.copyWith(poses: updatedPoses);

    emit(currentState.copyWith(flow: updatedFlow));
  }

  /// Save the flow and its poses (local + remote)
  Future<void> saveFlow(String token) async {
    if (state is! EditFlowState) return;
    final currentState = state as EditFlowState;

    emit(currentState.copyWith(isSaving: true));

    try {
      await _flowRepository.updateFlow(
        updatedFlow: currentState.flow,
        token: token,
      );
      await _flowPoseRepository.replaceFlowPosesInFlow(
        flowId: currentState.flow.id,
        newPoses: currentState.flow.poses,
      );
      emit(currentState.copyWith(isSaving: false, saveSuccess: true));
    } catch (e) {
      print("Error saving flow: $e");
      emit(currentState.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }
}
