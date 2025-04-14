import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/repositories/transition_remote_repository.dart';
import 'package:frontend/repositories/transition_local_repository.dart';
import 'package:frontend/models/transition_model.dart';

part 'transition_state.dart';

class TransitionCubit extends Cubit<TransitionState>{
  TransitionCubit() : super(TransitionInitial());
  final transitionRemoteRepository = TransitionRemoteRepository();
  final transitionLocalRepository = TransitionLocalRepository();

  Future<void> createNewTransition({
    required String fromPoseId, // TODO Change to path OR TRANSITIONPATH
    required String toPoseId,
    required String name,
    required String description,
    required String cues,
    required int difficulty,
    required double duration,
    required String primaryVideoId,
    required String token,


  }) async {
    try {
      emit(TransitionLoading());
      final transitionModel = await transitionRemoteRepository.createTransition(
        fromPoseId: fromPoseId,
        toPoseId: toPoseId,
        name: name,
        description: description,
        cues: cues,
        difficulty: difficulty,
        duration: duration,
        primaryVideoId: primaryVideoId,
        token: token,

      );
      await transitionLocalRepository.insertTransition(transitionModel); // TODO isSynced = 0 when remote failed - is this defined?

      emit(AddNewTransitionSuccess(transitionModel));
    } catch (e) {
      print(e.toString());
      emit(TransitionError(e.toString()));
    }
  }

  Future<void> getAllTransition({required String token,
  }) async {
    try {
      emit(TransitionLoading());
      final transitionList = await transitionRemoteRepository.getTransitionList(token: token);

      emit(GetTransitionListSuccess(transitionList));

    } catch (e) {
      print(e.toString());
      emit(TransitionError(e.toString()));
    }
  }

  Future<void> syncTransition(String token) async {
    // get all unsynced transition from our sqlite db
    final unsyncedTransition = await transitionLocalRepository.getUnsyncedTransition();
    print(unsyncedTransition);
    if (unsyncedTransition.isEmpty) {
      return;
    }
    // talk to our postgresql db to add the new transition
    final isSynced = await transitionRemoteRepository.syncTransition(
        token: token,
        transitionList: unsyncedTransition
    );
    // change the transition rows that were added to the db from 0 to 1
    if (isSynced) {
      print("Unsynced transition have been synced");
      for (final transition in unsyncedTransition) {
        transitionLocalRepository.updateSyncedStatus(transition.id, 1);
      }
    }

  }
}

// TODO see his next video on background plugin that syncs every 7 days.
