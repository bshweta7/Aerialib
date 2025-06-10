import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/features/transitions/domain/transition_entity.dart';
import 'package:frontend/features/transitions/domain/transition_repository.dart';

part 'transition_state.dart';

class TransitionCubit extends Cubit<TransitionState> {
  final TransitionRepository _transitionRepository;
  bool _isSyncing = false;

  TransitionCubit(this._transitionRepository) : super(const TransitionInitial());

  /// Create a new transition
  Future<void> createNewTransition({
    required TransitionEntity transition,
    required String token,
  }) async {
    try {
      emit(const TransitionLoading());

      final createdTransition = await _transitionRepository.createTransition(
        transition: transition,
        token: token,
      );

      // TODO - see if commenting this out breaks anything (router)
      //  emit(AddNewTransitionSuccess(createdTransition));
      final allTransitions = await _transitionRepository.getAllTransitions();
      emit(GetTransitionsSuccess(allTransitions));

    } catch (e) {
      log("[TransitionCubit] Error creating transition: $e");
      emit(TransitionError(e.toString()));
    }
  }

  /// Fetch all transitions (from local storage or remote if needed)
  Future<void> getAllTransitions({required String token}) async {
    try {
      log('[TransitionsCubit] Fetching transitions...');
      emit(const TransitionLoading());

      List<TransitionEntity> allTransitions = await _transitionRepository.getAllTransitions();  // Fetch local transitions
      log('[TransitionsCubit] Number of Transitions Retrieved: ${allTransitions.length}');
      emit(GetTransitionsSuccess(allTransitions));

    } catch (e) {
      log('[TransitionsCubit] GetAllTransitions failed: $e');
      emit(TransitionError(e.toString()));
    }
  }

  /// Returns all transitions that end with the given pose ID (i.e., to_pose_id == poseId)
  Future<List<TransitionEntity>> getIncomingTransitionsForPose(String poseId) async {
    try {
      final allTransitions = await _transitionRepository.getAllTransitions();
      final incomingTransitions = allTransitions.where((t) => t.toPoseId == poseId).toList();
      return incomingTransitions;
    } catch (e) {
      log('[TransitionCubit] Error getting incoming transitions: $e');
      emit(TransitionError('[TransitionCubit] Error: $e'));
      return [];
    }
  }

  /// Run a one-time sync of transitions when network is available (sync the unsynced local transitions with remote)
  Future<void> syncTransitions({required String token}) async {
    if (_isSyncing) return;
    _isSyncing = true;

    // log("[TransitionsCubit] Starting one-shot sync...");

    try {
      await _transitionRepository.syncLocalToRemote(token);
      // log('[TransitionsCubit] Synced local to remote.');

      await _transitionRepository.syncRemoteToLocal(token);
      // log('[TransitionsCubit] Synced remote to local.');

      final allTransitions = await _transitionRepository.getAllTransitions();
      emit(GetTransitionsSuccess(allTransitions));
    } catch (e) {
      log('[TransitionsCubit] Sync error: $e');
      emit(TransitionError('[TransitionsCubit] Sync error: $e'));
    } finally {
      _isSyncing = false;
    }
  }

  /// Update transition info (both local and remote)
  Future<void> updateTransitionInfo({
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
      final allTransitions = await _transitionRepository.getAllTransitions();
      emit(GetTransitionsSuccess(allTransitions));

    } catch (e) {
      log(e.toString());
      emit(TransitionError(e.toString()));
    }
  }

  /// Delete a transition
  Future<void> deleteTransition({
    required String transitionId,
    required String token,
  }) async {
    try {
      emit(const TransitionLoading());
      await _transitionRepository.deleteTransitionRemote(id: transitionId, token: token);
      emit(DeleteTransitionSuccess(transitionId));

      final allTransitions = await _transitionRepository.getAllTransitions();
      emit(GetTransitionsSuccess(allTransitions));
    } catch (e) {
      log('[TransitionsCubit] Deleting error: $e');
      emit(TransitionError('[TransitionsCubit] Deleting error: $e'));
    }
  }


  Future<void> refresh({required String token}) async {
    try {
      emit(const TransitionLoading());
      final allTransitions = await _transitionRepository.getAllTransitions();
      emit(GetTransitionsSuccess(allTransitions));
    } catch (e) {
      emit(TransitionError('Refresh error: ${e.toString()}'));
    }
  }

  Future<void> refreshLocalOnly() async {
    try {
      final allTransitions = await _transitionRepository.getAllTransitions();
      emit(GetTransitionsSuccess(allTransitions));
    } catch (e) {
      emit(TransitionError('Local refresh error: ${e.toString()}'));
    }
  }

}
