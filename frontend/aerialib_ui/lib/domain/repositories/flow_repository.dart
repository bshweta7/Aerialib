import 'package:frontend/data/datasources/flows/flow_local_data.dart';
import 'package:frontend/data/datasources/flows/flow_remote_data.dart';
import 'package:frontend/data/datasources/media/media_local_data.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/data/models/flow_model.dart';
import 'package:frontend/data/models/media_model.dart';
import 'package:frontend/domain/mappers/flow_mapper.dart';

import '../../core/constants/constants.dart';

class FlowRepository {
  final FlowLocalDataSource localDataSource;
  final FlowRemoteDataSource remoteDataSource;
  final MediaLocalDataSource mediaLocalDataSource;

  FlowRepository({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.mediaLocalDataSource,
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
    required String createdBy,
    required String token,
  }) async {
    try {
      final flowModel = await remoteDataSource.createFlow(
        name: name,
        description: description,
        teachingCues: teachingCues,
        safetyCues: safetyCues,
        progressions: progressions,
        apparatus: apparatus,
        level: level,
        thumbnailImageId: thumbnailImageId,
        createdBy: createdBy,
        token: token,
      );
      await localDataSource.insertFlow(flowModel);

      final mediaList = await mediaLocalDataSource.getPoseMedia();
      final imagePath = mediaList
          .firstWhere(
            (m) => m.id == flowModel.thumbnailImageId,
        orElse: () => MediaModel(path: Constants.missingImagePath, type: '', uploadedBy: '', uploadedAt: DateTime.now(), id: '', isSynced: 0),
      )
          .path;

      return FlowMapper.modelToEntityMetaDataOnly(flowModel, thumbnailImagePath: imagePath);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch all flows from local DB - initialize poses as []
  Future<List<FlowEntity>> getLocalFlows() async {
    final flowModels = await localDataSource.getFlows();
    final mediaList = await mediaLocalDataSource.getPoseMedia();
    final mediaMap = {
      for (var m in mediaList) m.id: m.path,
    };

    return flowModels.map((model) {
      final imagePath = mediaMap[model.thumbnailImageId] ?? Constants.missingImagePath;
      return FlowMapper.modelToEntityMetaDataOnly(model, thumbnailImagePath: imagePath);
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

    final success = await remoteDataSource.syncFlows(
      token: token,
      flows: unsynced,
    );

    if (success) {
      for (final flow in unsynced) {
        await localDataSource.setSyncedStatus(flow.id, 1);
      }
    }
  }

  /// Update a flow remotely and locally
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
