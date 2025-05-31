import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/features/transitions/domain/entities/transition_entity.dart';
import 'package:frontend/features/transitions/domain/repositories/transition_repository.dart';

part 'transition_state.dart';

class TransitionCubit extends Cubit<TransitionState> {
  final TransitionRepository _transitionRepository;

  TransitionCubit(this._transitionRepository) : super(const TransitionInitial());

  /// Create a new transition
  Future<void> createTransition({
    required String fromPoseId,
    required String toPoseId,
    required double level,
    String? name,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    String? transitionType,
    String? startingGrip,
    String? endingGrip,
    required String createdBy,
    required String token,
  }) async {
    try {
      emit(const TransitionLoading());

      final transition = await _transitionRepository.createTransition(
        fromPoseId: fromPoseId,
        toPoseId: toPoseId,
        level: level,
        name: name,
        description: description,
        teachingCues: teachingCues,
        safetyCues: safetyCues,
        progressions: progressions,
        transitionType: transitionType,
        startingGrip: startingGrip,
        endingGrip: endingGrip,
        createdBy: createdBy,
        token: token,
      );

      emit(CreateTransitionSuccess(transition));
    } catch (e) {
      emit(TransitionError("Failed to create transition: $e"));
    }
  }

  /// Get all transitions (local or remote fallback)
  Future<void> getAllTransitions({required String token}) async {
    try {
      emit(const TransitionLoading());

      var transitions = await _transitionRepository.getLocalTransitions();
      if (transitions.isEmpty) {
        await _transitionRepository.syncRemoteToLocal(token);
        transitions = await _transitionRepository.getLocalTransitions();
      }

      emit(GetTransitionsSuccess(transitions));
    } catch (e) {
      emit(TransitionError("Failed to get transitions: $e"));
    }
  }

  /// Sync unsynced transitions
  Future<void> syncTransitions(String token) async {
    try {
      final result = await Connectivity().checkConnectivity();
      if (result != ConnectivityResult.none) {
        await _transitionRepository.syncLocalToRemote(token);
        await _transitionRepository.syncRemoteToLocal(token);
      } else {
        log("No connection for sync");
      }
    } catch (e) {
      emit(TransitionError("Sync failed: $e"));
    }
  }

  /// Update a transition
  Future<void> updateTransition({
    required TransitionEntity updatedTransition,
    required String token,
  }) async {
    try {
      emit(const TransitionLoading());
      await _transitionRepository.updateTransition(
        updatedTransition: updatedTransition,
        token: token,
      );
      emit(UpdateTransitionSuccess(updatedTransition));
    } catch (e) {
      emit(TransitionError("Failed to update: $e"));
    }
  }

  /// Delete locally
  Future<void> deleteTransition(String id) async {
    try {
      emit(const TransitionLoading());
      await _transitionRepository.deleteTransition(id);
      final transitions = await _transitionRepository.getLocalTransitions();
      emit(GetTransitionsSuccess(transitions));
    } catch (e) {
      emit(TransitionError("Failed to delete: $e"));
    }
  }
}
