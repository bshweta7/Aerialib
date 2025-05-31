import 'dart:developer';

import 'package:frontend/features/flow/data/datasources/flow/flow_local_data.dart';
import 'package:frontend/features/flow/data/datasources/flow/flow_remote_data.dart';
import 'package:frontend/features/flow/data/models/flow_model.dart';

import 'package:frontend/features/flow/domain/mappers/flow_mapper.dart';
import 'package:frontend/features/flow/domain/entities/flow_entity.dart';


class FlowRepository {
  final FlowLocalDataSource localDataSource;
  final FlowRemoteDataSource remoteDataSource;

  FlowRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Create a new flow (tries remote first, fallback to local if offline)
  Future<FlowEntity> createFlow({
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
      log("[FlowRepository] Creating flow in remote db... ");
      final flowModel = await remoteDataSource.createFlow(
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
      log("[FlowRepository] Done, adding to local db... ");
      await localDataSource.insertFlow(flowModel);

      log("[FlowRepository] Done, returning flow entity ... ");

      return FlowMapper.modelToEntityDetailsOnly(flowModel);
    } catch (e) {
      log("[FlowRepository] Failed to create remotely... ");
      rethrow;
    }
  }

  /// Fetch all flows from local DB - initialize poses as []
  Future<List<FlowEntity>> getAllFlowDetails() async {
    final flowModels = await localDataSource.getFlows();

    return flowModels.map((model) {
      return FlowMapper.modelToEntityDetailsOnly(model);
    }).toList();
  }

  /// Fetch all flows from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    final flowModels = await remoteDataSource.fetchRemoteFlows(token: token);
    await localDataSource.insertFlows(flowModels);
  }

  /// Send unsynced local flows to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<FlowModel> unsynced = await localDataSource.getUnsyncedFlows();
    if (unsynced.isEmpty) return;

    log("[FlowRepository] Fetched ${unsynced.length} unsynced flows from local data source");

    // for (final flow in unsynced) {
    //   final flowMap = flow.toMap(); // or toMap() if you use that instead
    //
    //   log("[FlowRepository] Flow ID: ${flow.id}");
    //   flowMap.forEach((key, value) {
    //     log("  $key: $value");
    //   });
    // }

    final success = await remoteDataSource.syncFlows(
      token: token,
      flows: unsynced,
    );

    if (success) {
      for (final flow in unsynced) {
        await localDataSource.setSyncedStatus(flow.id, 1);
      }
    }

    log("[FlowRepository] Synced flows to remote");
    log("[FlowRepository] Success $success");


  }

  /// Update a flow remotely and locally
  Future<void> updateFlow({
    required FlowEntity updatedFlow,
    required String token,
  }) async {
    final flowModel = FlowMapper.entityToModel(updatedFlow);

    log("[FlowRepository] Updating pose remotely...");
    final updatedModel = await remoteDataSource.updateFlow(
      updatedFlow: flowModel,
      token: token,
    );
    log("[FlowRepository] Remote update successful");

    log("[FlowRepository] Updating pose locally...");
    await localDataSource.updateFlow(updatedModel);
    log("[FlowRepository] Local update successful");

  }

  /// Delete locally
  Future<void> deleteFlowLocally(String id) async {
    await localDataSource.deleteFlow(id);
  }

  /// Delete locally and remote
  Future<void> deleteFlow(String id, token) async {
    try {
      await remoteDataSource.deleteFlowById(id, token);
    } catch (e){
      log("[FlowRepository] Error deleting flow from remote data source: $e");
    }
      // TODO only delete locally if remote is success, otherwise say "try again later when you have internet connection"
    await localDataSource.deleteFlow(id);
  }
}
