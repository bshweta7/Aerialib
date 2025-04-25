import 'package:frontend/data/datasources/flows/flow_local_data.dart';
import 'package:frontend/data/datasources/flows/flow_remote_data.dart';
import 'package:frontend/domain/entities/flow_entity.dart';

import '../../data/models/flow_model.dart';
import '../mappers/flow_mapper.dart';

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
    required String description,
    required String apparatus,
    required String createdBy,
    required String token,
  }) async {
    try {
      // Create remotely
      final flowModel = await remoteDataSource.createFlow(
        name: name,
        description: description,
        apparatus: apparatus,
        createdBy: createdBy, 
        token: token,
      );
      await localDataSource.insertFlow(flowModel);

      return FlowMapper.modelToEntityMetaDataOnly(flowModel);
    } catch (e) {
      // TODO: Handle offline fallback or local-only mode if needed
      rethrow;
    }
  }


  /// Fetch all flows from local DB - initialize poses as []
  Future<List<FlowEntity>> getLocalFlows() async {
    print("Fetching Flow Models from Local Database");
    final flowModels = await localDataSource.getFlows();
    print("Converting to Flow Models to Entities (where poses is empty)");
    return flowModels.map((model) {
      return FlowMapper.modelToEntityMetaDataOnly(model);
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
    if (unsynced.isEmpty) {
      return;
    }

    print("Retrieved unsynced flows from local");
    final success = await remoteDataSource.syncFlows(
      token: token,
      flows: unsynced,
    );
    print("Synced flows to remote");

    if (success) {
      for (final flow in unsynced) {
        await localDataSource.setSyncedStatus(flow.id, 1);
      }
      print("Updated flows synced status to synced");
    }
  }


  /// Update a pose remotely and locally
  Future<void> updateFlow({
    required FlowEntity updatedFlow,
    required String token,
  }) async {
    final flowModel = FlowMapper.entityToModel(updatedFlow);
    final updatedModel = await remoteDataSource.updateFlow(
      updatedFlow: flowModel,
      token: token,
    );
    await localDataSource.updateFlow(updatedModel);
  }

  /// Delete locally
  Future<void> deleteFlow(String id) async {
    await localDataSource.deleteFlow(id);
  }
}
