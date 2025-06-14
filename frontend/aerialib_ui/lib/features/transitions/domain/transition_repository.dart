import 'dart:developer';

import 'package:frontend/features/transitions/domain/transition_entity.dart';
import 'package:frontend/features/transitions/domain/transition_mapper.dart';

import 'package:frontend/features/transitions/data/transition_local_data.dart';
import 'package:frontend/features/transitions/data/transition_remote_data.dart';
import 'package:frontend/features/transitions/data/transition_model.dart';


class TransitionRepository {
  final TransitionLocalDataSource localDataSource;
  final TransitionRemoteDataSource remoteDataSource;

  TransitionRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Create a new transition (tries remote first, fallback to local if offline)
  Future<TransitionEntity> createTransition({
    required TransitionEntity transition,
    required String token,
  }) async {
    try {
      log('[TransitionRepository] Creating transition remotely...');

      // Convert to model and send to backend
      final transitionModel = await remoteDataSource.createTransition(
        transition: TransitionMapper.entityToModel(transition),
        token: token,
      );

      // Save to local DB
      await localDataSource.createTransition(transitionModel);
      // log('[TransitionRepository] Transition inserted into local database.');

      // Return as entity
      final entity = TransitionMapper.modelToEntity(transitionModel);
      log('[TransitionRepository] Mapped TransitionModel to TransitionEntity: ${entity.id}');
      return entity;

    } catch (e) {
      log('[TransitionRepository] Error creating transition: $e');
      rethrow;
    }
  }

  /// Fetch all transitions from local DB
  Future<List<TransitionEntity>> getAllTransitions() async {
    final transitionModels = await localDataSource.getAllTransitions();
    final transitionEntitiesList = TransitionMapper.modelsToEntities(transitionModels);
    log('[TransitionsRepository] Got ${transitionModels.length} transition entities from local database');
    return transitionEntitiesList;
  }


  // TODO get all transitions - try to sync and if not possible, return local transitions with note that its local only (or last synced time)

  /// Fetch all transitions from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    try {
      final transitionModels = await remoteDataSource.getRemoteTransitions(token: token);
      await localDataSource.createTransitions(transitionModels);
      log('[TransitionRepository] Synced ${transitionModels.length} remote transitions to local.');
    } catch (e) {
      log('[TransitionRepository] Failed syncing remote transitions to local: $e');
      rethrow;
    }
  }

  /// Send unsynced local transitions to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<TransitionModel> unsynced = await localDataSource.getUnsyncedTransitions();
    if (unsynced.isEmpty) {
      log("[TransitionRepository] No unsynced transitions found.");
      return;
    }

    log("[TransitionRepository] Attempting to sync ${unsynced.length} transitions to remote...");
    final success = await remoteDataSource.syncTransitions(
      token: token,
      transitions: unsynced,
    );

    if (success) {
      for (final transition in unsynced) {
        await localDataSource.updateSyncStatus(transition.id, 1);
      }
      log("[TransitionRepository] Successfully updated sync status locally.");
    } else {
      log("[TransitionRepository] Remote sync failed. Sync status not updated.");
    }
  }

  /// Update a transition remotely and locally using sync
  Future<void> updateTransition({
    required TransitionEntity updatedTransition,
    required String token,
  }) async {
    final transitionModel = TransitionMapper.entityToModel(updatedTransition);

    log("[TransitionRepository] Syncing updated transition remotely...");
    final success = await remoteDataSource.syncTransitions(
      token: token,
      transitions: [transitionModel], // Just pass this one updated transition
    );

    if (success) {
      final syncedModel = transitionModel.copyWith(isSynced: 1);
      log("[TransitionRepository] Updating transition locally...");
      await localDataSource.updateTransition(syncedModel);
    } else {
      log("[TransitionRepository] Remote sync failed. Transition not updated locally."); // TODO shouldn't just fail to update locally...
      throw Exception("Failed to update transition remotely via sync.");
    }
  }

  /// Delete Transition
  Future<void> deleteTransition({
    required String id,
    required String token,
  }) async {
    await remoteDataSource.deleteTransition(transitionId: id, token: token);
    await localDataSource.deleteTransition(id);
    log('[TransitionRepository] Transition $id deleted from both remote and local.');
  }

}