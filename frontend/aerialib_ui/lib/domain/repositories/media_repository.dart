import 'package:frontend/data/datasources/media/media_local_data.dart';
import 'package:frontend/data/datasources/media/media_remote_data.dart';
import 'package:frontend/data/models/media_model.dart';
import 'package:frontend/domain/entities/media_entity.dart';

import '../mappers/media_mapper.dart';
import 'dart:io';
import 'package:mime/mime.dart';

class MediaRepository {
  final MediaLocalDataSource localDataSource;
  final MediaRemoteDataSource remoteDataSource;

  MediaRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  String? _getMediaTypeFromPath(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType?.split('/').first;
  }

  Future<int> _getFileSizeInBytes(String filePath) async {
    final file = File(filePath);
    return await file.length();
  }

  /// Create a new media (tries remote first, fallback to local if offline)
  Future<MediaEntity> createMedia({
    required String path,
    String? primaryMedia,
    String? name,
    String? description,
    String? apparatus,
    required String uploadedBy,
    required String token,
  }) async {

    final type = _getMediaTypeFromPath(path) ?? 'unknown';
    final fileSize = await _getFileSizeInBytes(path);

    try {
      final mediaModel = await remoteDataSource.createMedia(
        path: path,
        type: type,
        fileSize: fileSize,
        primaryMedia: primaryMedia,
        name: name,
        description: description,
        apparatus: apparatus,
        uploadedBy: uploadedBy,
        token: token,
      );

      await localDataSource.insertMedia(mediaModel);
      return MediaMapper.modelToEntity(mediaModel);
    } catch (e) {
      // TODO Handle other potential errors (e.g., local database issues)
      rethrow;
    }
  }

  /// Fetch all medias from local DB
  Future<List<MediaEntity>> getLocalMedias() async {
    print("Fetching MediaModels from Local Database");
    final mediaModels = await localDataSource.getMediaList();
    print("Converting to Media Models to Entities");
    return MediaMapper.modelsToEntities(mediaModels);
  }

  // TODO get all medias - try to sync and if not possible, return local medias with note that its local only (or last synced time)

  /// Fetch all medias from remote API and save locally
  Future<void> syncRemoteToLocal(String token) async {
    print("[MediaRepository] Fetching from remote data source");
    final mediaModels = await remoteDataSource.fetchRemoteMediaList(token: token);

    print("[MediaRepository] Inserting data into local data source");
    await localDataSource.insertMediaList(mediaModels);
  }


  /// Send unsynced local medias to remote, and mark them as synced
  Future<void> syncLocalToRemote(String token) async {
    final List<MediaModel> unsynced = await localDataSource.getUnsyncedMedia();
    if (unsynced.isEmpty) {
      return;
    }

    print("Retrieved unsynced medias from local");
    final success = await remoteDataSource.syncMedia(
      token: token,
      mediaList: unsynced,
    );
    print("Synced medias to remote");

    if (success) {
      for (final media in unsynced) {
        await localDataSource.setSyncedStatus(media.id, 1);
      }
    }
  }

  // /// Full sync (both directions)
  // Future<void> fullSync(String token) async {
  //   await syncLocalToRemote(token);
  //   await syncRemoteToLocal(token);
  // }

  /// Update a media remotely and locally
  Future<void> updateMedia({
    required MediaEntity updatedMedia,
    required String token,
  }) async {
    final mediaModel = MediaMapper.entityToModel(updatedMedia);

    final updatedModel = await remoteDataSource.updateMedia(
      updatedMedia: mediaModel,
      token: token,
    );

    await localDataSource.updateMedia(updatedModel);
  }

  /// Delete locally
  Future<void> deleteMedia(String id) async {
    await localDataSource.deleteMedia(id);
  }
}
