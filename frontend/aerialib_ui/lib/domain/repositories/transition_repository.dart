import 'package:frontend/data/datasources/transitions/transition_local_data.dart';
import 'package:frontend/data/datasources/transitions/transition_remote_data.dart';
import 'package:frontend/data/models/transition_model.dart';
import 'package:frontend/domain/entities/transition_entity.dart';
import 'package:frontend/domain/mappers/transition_mapper.dart';

class TransitionRepository {
  final TransitionLocalDataSource localDataSource;
  final TransitionRemoteDataSource remoteDataSource;

  TransitionRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Create a new transition (tries remote first, fallback to local if offline)
  Future<TransitionEntity> createTransition({
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
      final transitionModel = await remoteDataSource.createTransition(
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

      await localDataSource.insertTransition(transitionModel);
      return TransitionMapper.modelToEntity(transitionModel);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch all transitions from local DB
  Future<List<TransitionEntity>> getLocalTransitions() async {
    final models = await localDataSource.getTransitions();
    return TransitionMapper.modelsToEntities(models);
  }

  /// Fetch all transitions from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    final models = await remoteDataSource.fetchRemoteTransitions(token: token);
    await localDataSource.insertTransitions(models);
  }

  /// Send unsynced local transitions to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<TransitionModel> unsynced = await localDataSource.getUnsyncedTransitions();
    if (unsynced.isEmpty) return;

    final success = await remoteDataSource.syncTransitions(
      token: token,
      transitions: unsynced,
    );

    if (success) {
      for (final model in unsynced) {
        await localDataSource.setSyncedStatus(model.id, 1);
      }
    }
  }

  /// Update transition remotely and locally
  Future<void> updateTransition({
    required TransitionEntity updatedTransition,
    required String token,
  }) async {
    final model = TransitionMapper.entityToModel(updatedTransition);

    final updatedModel = await remoteDataSource.updateTransition(
      updatedTransition: model,
      token: token,
    );

    await localDataSource.updateTransition(updatedModel);
  }

  /// Delete locally
  Future<void> deleteTransition(String id) async {
    await localDataSource.deleteTransition(id);
  }
}
