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

  /// Detects media type from file path using MIME
  String? _getMediaTypeFromPath(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType?.split('/').first;
  }

  /// Gets the file size of a local file
  Future<int> _getFileSizeInBytes(String filePath) async {
    final file = File(filePath);
    return await file.length();
  }

  /// Create a new media item (metadata only — no file upload yet)
  Future<MediaEntity> createMedia({
    required String path,
    String? name,
    String? description,
    String? apparatus,
    required String uploadedBy,
    required String token,
  }) async {
    final type = _getMediaTypeFromPath(path) ?? 'unknown';
    final fileSize = await _getFileSizeInBytes(path);

    final mediaModel = MediaModel(
      id: UniqueKey().toString(), // or UUID logic
      mediaPath: path,
      mediaType: type,
      fileSize: fileSize,
      durationSeconds: null,
      name: name,
      description: description,
      apparatus: apparatus,
      origin: "local",
      takenTime: null,
      takenLocation: null,
      createdBy: uploadedBy,
      updatedBy: uploadedBy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: 0,
    );

    try {
      final remoteMedia = await remoteDataSource.createMedia(
        media: mediaModel,
        token: token,
      );

      await localDataSource.createMedia(remoteMedia);
      return MediaMapper.modelToEntity(remoteMedia.copyWith(isSynced: 1));
    } catch (e) {
      log("[MediaRepository] Remote create failed, saving locally");
      await localDataSource.createMedia(mediaModel);
      return MediaMapper.modelToEntity(mediaModel);
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
      log("[MediaRepository] Updating media locally...");
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