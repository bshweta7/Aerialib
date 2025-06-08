import 'dart:developer';
import 'dart:convert';

import 'package:frontend/features/media/data/models/media_model.dart';
import 'package:frontend/core/services/http_service.dart';

class MediaRemoteDataSource {
  final HttpService httpService;

  MediaRemoteDataSource({required this.httpService});

  /// Create and return MediaModel
  // TODO meta data only right now, should also send the file
  Future<MediaModel> createMedia({
    required MediaModel media,
    required String token,
  }) async {
    try {
      final response = await httpService.post(
        path: "/media",
        token: token,
        body: media.toMapRemote(),
      );

      final createdMedia = MediaModel.fromJson(response.body);
      return createdMedia.copyWith(isSynced: 1);
    } catch (e) {
      // Fallback: return original media marked as not synced
      return media.copyWith(isSynced: 0);
    }
  }

  /// Get all media from remote database
  Future<List<MediaModel>> getRemoteMedia({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/media",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => MediaModel.fromMap(e).copyWith(isSynced: 1)).toList();
  }

  /// Sync media from local to remote (metadata only)
  Future<bool> syncMedia({
    required String token,
    required List<MediaModel> mediaList,
  }) async {
    final mediaListInMap = mediaList.map((m) => m.toMapRemote()).toList();

    log('[MediaRemoteDataSource] Syncing ${mediaListInMap.length} media items...');
    for (final map in mediaListInMap) {
      log('[MediaRemoteDataSource] Syncing media path: ${map['mediaPath']}');
    }

    final response = await httpService.post(
      path: "/media/sync",
      token: token,
      body: mediaListInMap,
    );

    if (response.statusCode == 201) {
      log('[MediaRemoteDataSource] Sync successful');
      return true;
    } else {
      log('[MediaRemoteDataSource] Sync failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  /// Delete a media item
  Future<void> deleteMedia({
    required String mediaId,
    required String token,
  }) async {
    final response = await httpService.delete(
      path: "/media/delete/$mediaId",
      token: token,
    );

    if (response.statusCode != 200) {
      log("[MediaRemoteDataSource] Failed to delete media, status ${response.statusCode}");
      log("[MediaRemoteDataSource] Body: ${response.body}");
      throw Exception("[MediaRemoteDataSource] Failed to delete media remotely");
    }

    log("[MediaRemoteDataSource] Media deleted successfully: $mediaId");
  }
}