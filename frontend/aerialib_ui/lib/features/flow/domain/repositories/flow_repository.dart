import 'dart:developer';

import 'package:frontend/features/flow/data/datasources/flow/flow_local_data.dart';
import 'package:frontend/features/flow/data/datasources/flow/flow_remote_data.dart';
import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
import 'package:frontend/features/flow/domain/mappers/flow_mapper.dart';

class FlowRepository {
  final FlowLocalDataSource localDataSource;
  final FlowRemoteDataSource remoteDataSource;

  FlowRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Create a new flow remotely, then save it locally
  Future<FlowEntity> createFlow({
    required FlowEntity flow,
    // required List<FlowPoseEntity> flowPoses,
    required String token,
  }) async {
    try {
      log('[FlowRepository] Creating flow remotely...');
      final flowModel = await remoteDataSource.createFlow(
        flow: FlowMapper.entityToModel(flow),
        token: token,
      );

      log('[FlowRepository] Saving created flow locally...');
      await localDataSource.createFlow(flowModel);

      return FlowMapper.modelToEntity(flowModel);
    } catch (e) {
      log('[FlowRepository] Failed to create flow remotely: $e');
      rethrow;
    }
  }

  /// Fetch all flows from local DB
  // TODO only getting details right now....
  Future<List<FlowEntity>> getAllFlowDetails() async {
    final flowModels = await localDataSource.getAllFlows();
    return FlowMapper.modelsToEntities(flowModels);
  }

  /// Sync all flows from remote API into local DB
  Future<void> syncRemoteToLocal(String token) async {
    try {
      final flowModels = await remoteDataSource.getRemoteFlows(token: token);
      await localDataSource.createFlows(flowModels);
      log('[FlowRepository] Synced ${flowModels.length} remote flows to local.');
    } catch (e) {
      log('[FlowRepository] Failed syncing remote flows to local: $e');
      rethrow;
    }
  }

  /// Sync all unsynced local flows to remote
  Future<void> syncLocalToRemote(String token) async {
    final unsynced = await localDataSource.getUnsyncedFlows();
    if (unsynced.isEmpty) {
      log('[FlowRepository] No unsynced flows found.');
      return;
    }

    log('[FlowRepository] Attempting to sync ${unsynced.length} flows...');
    final success = await remoteDataSource.syncFlows(
      token: token,
      flows: unsynced,
    );

    if (success) {
      for (final model in unsynced) {
        await localDataSource.updateSyncStatus(model.id, 1);
      }
      log('[FlowRepository] Sync successful. Local sync status updated.');
    } else {
      log('[FlowRepository] Remote sync failed. Local sync status not updated.');
    }
  }

  /// Update a flow remotely and locally using sync
  Future<void> updateFlow({
    required FlowEntity updatedFlow,
    required String token,
  }) async {
    final flowModel = FlowMapper.entityToModel(updatedFlow);

    log("[FlowRepository] Syncing updated flow remotely...");
    final success = await remoteDataSource.syncFlows(
      token: token,
      flows: [flowModel], // Sync just this one
    );

    if (success) {
      final syncedModel = flowModel.copyWith(isSynced: 1);
      log("[FlowRepository] Updating flow locally...");
      await localDataSource.updateFlow(syncedModel);
    } else {
      log("[FlowRepository] Remote sync failed. Flow not updated locally.");
      throw Exception("Failed to update flow remotely via sync.");
    }
  }


  /// Delete Flow (remote first, then local)
  Future<void> deleteFlow({
    required String id,
    required String token,
  }) async {
    await remoteDataSource.deleteFlow(id: id, token: token);
    await localDataSource.deleteFlow(id);
    log('[FlowRepository] Flow $id deleted from both remote and local.');
  }

  /// Delete Flow (remote first, then local)
  Future<void> deleteFlowLocally({
    required String flowId,
  }) async {
    await localDataSource.deleteFlow(flowId);
    log('[FlowRepository] Flow $flowId deleted from local.');
  }


}
