import 'dart:developer';
import 'package:frontend/features/tags/data/tag_local_data.dart';
import 'package:frontend/features/tags/data/tag_remote_data.dart';
import 'package:frontend/features/tags/domain/tag_entity.dart';
import 'package:frontend/features/tags/domain/tag_mapper.dart';

class TagRepository {
  final TagLocalDataSource localDataSource;
  final TagRemoteDataSource remoteDataSource;

  TagRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Create a new tag remotely and insert locally
  Future<TagEntity> createTag({
    required String name,
    String? color,
    required String userId,
    required String token,
  }) async {
    try {
      final model = await remoteDataSource.createTag(
        name: name,
        color: color,
        createdBy: userId,
        token: token,
      );

      await localDataSource.insertTag(model);
      return TagMapper.modelToEntity(model);
    } catch (e) {
      log('[TagRepository] Remote create failed, rethrowing: $e');
      rethrow;
    }
  }

  /// Get all tags locally (returns user + admin tags)
  Future<List<TagEntity>> getAllTags() async {
    final models = await localDataSource.getTags();
    return models.map(TagMapper.modelToEntity).toList();
  }

  /// Sync remote tags to local
  Future<void> syncRemoteToLocal(String token) async {
    final models = await remoteDataSource.fetchRemoteTags(token: token);
    await localDataSource.insertTags(models);
  }

  /// Sync unsynced local tags to remote
  Future<void> syncLocalToRemote(String token) async {
    final unsynced = await localDataSource.getUnsyncedTags();
    if (unsynced.isEmpty) return;

    final success = await remoteDataSource.syncTags(token: token, tags: unsynced);

    if (success) {
      for (final tag in unsynced) {
        await localDataSource.setSyncedStatus(tag.id, 1);
      }
    }
  }

  /// Update a tag
  Future<void> updateTag({
    required TagEntity updatedTag,
    required String token,
  }) async {
    final model = TagMapper.entityToModel(updatedTag);
    final updatedModel = await remoteDataSource.updateTag(token: token, updatedTag: model);
    await localDataSource.updateTag(updatedModel);
  }

  /// Delete a tag locally and remotely
  Future<void> deleteTagById(String id, String token) async {
    try {
      await remoteDataSource.deleteTagById(id, token);
    } catch (e) {
      log('[TagRepository] Remote delete failed: $e');
    }

    await localDataSource.deleteTag(id);
  }
}
