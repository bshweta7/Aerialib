import 'dart:io';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';

import 'package:frontend/features/media/domain/mappers/media_mapper.dart';
import 'package:frontend/features/media/domain/entities/media_entity.dart';

import 'package:frontend/features/media/data/datasources/media_local_data.dart';
import 'package:frontend/features/media/data/datasources/media_remote_data.dart';
import 'package:frontend/features/media/data/models/media_model.dart';

class MediaRepository {
  final MediaLocalDataSource localDataSource;
  final MediaRemoteDataSource remoteDataSource;

  MediaRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Create a new media item (metadata only — no file upload yet)
  Future<MediaEntity> createMedia({
    required MediaEntity media,
    required String token,
  }) async {
    try {
      log('[MediaRepository] Creating media remotely...');

      // Convert to model and send to backend
      final mediaModel = await remoteDataSource.createMedia(
        media: MediaMapper.entityToModel(media),
        token: token,
      );

      // Save to local DB
      await localDataSource.createMedia(mediaModel);
      // log('[MediaRepository] Media inserted into local database.');

      // Return as entity
      final entity = MediaMapper.modelToEntity(mediaModel);
      log('[MediaRepository] Mapped MediaModel to MediaEntity: ${entity.id}');
      return entity;

    } catch (e) {
      log('[MediaRepository] Error creating media: $e');
      rethrow;
    }
  }

  /// Fetch all local media
  Future<List<MediaEntity>> getAllMedia() async {
    log('[MediaRepository] Fetching media from local database...');
    final mediaModels = await localDataSource.getAllMedia();
    final mediaEntities = MediaMapper.modelsToEntities(mediaModels);
    log('[MediaRepository] Got ${mediaModels.length} media items.');
    return mediaEntities;
  }

  /// Fetch media from remote and save locally
  Future<void> syncRemoteToLocal(String token) async {
    try {
      final mediaModels = await remoteDataSource.getRemoteMedia(token: token);
      await localDataSource.createMedias(mediaModels);
      log('[MediaRepository] Synced ${mediaModels.length} remote media items to local.');
    } catch (e) {
      log('[MediaRepository] Failed syncing remote media to local: $e');
      rethrow;
    }
  }

  /// Push unsynced local media to remote
  Future<void> syncLocalToRemote(String token) async {
    final unsynced = await localDataSource.getUnsyncedMedia();

    if (unsynced.isEmpty) {
      log("[MediaRepository] No unsynced media found.");
      return;
    }

    log("[MediaRepository] Syncing ${unsynced.length} media items to remote...");
    final success = await remoteDataSource.syncMedia(
      token: token,
      mediaList: unsynced,
    );

    if (success) {
      for (final media in unsynced) {
        await localDataSource.updateSyncStatus(media.id, 1);
      }
      log("[MediaRepository] Successfully updated sync status locally.");
    } else {
      log("[MediaRepository] Remote sync failed. Sync status not updated.");
    }
  }

  /// Update a media entry remotely and locally
  Future<void> updateMedia({
    required MediaEntity updatedMedia,
    required String token,
  }) async {
    final mediaModel = MediaMapper.entityToModel(updatedMedia);

    log("[MediaRepository] Syncing updated media remotely...");
    final success = await remoteDataSource.syncMedia(
      token: token,
      mediaList: [mediaModel],
    );

    if (success) {
      final syncedModel = mediaModel.copyWith(isSynced: 1);
      log("[MediaRepository] Updating media locally..."); // TODO if it fails it doesn't update locally...
      await localDataSource.updateMedia(syncedModel);
    } else {
      log("[MediaRepository] Remote sync failed. Media not updated locally.");
      throw Exception("Failed to update media remotely via sync.");
    }
  }

  /// Delete Media
  Future<void> deleteMediaRemote({
    required String id,
    required String token,
  }) async {
    await remoteDataSource.deleteMedia(mediaId: id, token: token);
    await localDataSource.deleteMedia(id);
    log('[MediaRepository] Media $id deleted from both remote and local.');
  }
}