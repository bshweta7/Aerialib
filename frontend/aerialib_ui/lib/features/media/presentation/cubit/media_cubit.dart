import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:frontend/features/media/domain/entities/media_entity.dart';
import 'package:frontend/features/media/domain/repositories/media_repository.dart';

part 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  final MediaRepository _mediaRepository;
  bool _isSyncing = false;

  MediaCubit(this._mediaRepository) : super(const MediaInitial());

  /// Create a new media (remote + local)
  Future<void> createNewMedia({
    required MediaEntity media,
    required String token,
  }) async {
    try {
      emit(const MediaLoading());

      final createdMedia = await _mediaRepository.createMedia(
        media: media,
        token: token
      );

      final allMedia = await _mediaRepository.getAllMedia();
      emit(GetMediaSuccess(allMedia));

    } catch (e) {
      log("[MediaCubit] Error creating media: $e");
      emit(MediaError(e.toString()));
    }
  }



  /// Fetch all medias (from local storage or remote if needed)
  Future<void> getAllMedia({required String token}) async {
    try {
      log('[MediasCubit] Fetching media...');
      emit(const MediaLoading());

      List<MediaEntity> allMedias = await _mediaRepository.getAllMedia();  // Fetch local medias
      log('[MediasCubit] Number of Medias Retrieved: ${allMedias.length}');
      emit(GetMediaSuccess(allMedias));

    } catch (e) {
      log('[MediasCubit] GetAllMedias failed: $e');
      emit(MediaError(e.toString()));
    }
  }

  /// Sync medias (sync unsynced local medias with remote)
  Future<void> syncMedia({required String token}) async {
    if (_isSyncing) return;
    _isSyncing = true;

    log("[MediasCubit] Starting one-shot sync...");

    try {
      await _mediaRepository.syncLocalToRemote(token);
      log('[MediasCubit] Synced local to remote.');

      await _mediaRepository.syncRemoteToLocal(token);
      log('[MediasCubit] Synced remote to local.');

      final allMedias = await _mediaRepository.getAllMedia();
      emit(GetMediaSuccess(allMedias));
    } catch (e) {
      log('[MediasCubit] Sync error: $e');
      emit(MediaError('[MediasCubit] Sync error: $e'));
    } finally {
      _isSyncing = false;
    }
  }

  /// Update media info (both local and remote)
  Future<void> updateMediaInfo({
    required MediaEntity updatedMedia,
    required String token,
  }) async {
    try {
      emit(const MediaLoading());
      await _mediaRepository.updateMedia(
        updatedMedia: updatedMedia,
        token: token,
      );
      emit(UpdateMediaSuccess(updatedMedia));
      final allMedias = await _mediaRepository.getAllMedia();
      emit(GetMediaSuccess(allMedias));

    } catch (e) {
      log(e.toString());
      emit(MediaError(e.toString()));
    }
  }

  /// Delete a media
  Future<void> deleteMedia({
    required String mediaId,
    required String token,
  }) async {
    try {
      emit(const MediaLoading());
      await _mediaRepository.deleteMediaRemote(id: mediaId, token: token);
      emit(DeleteMediaSuccess(mediaId));

      final allMedias = await _mediaRepository.getAllMedia();
      emit(GetMediaSuccess(allMedias));
    } catch (e) {
      log('[MediasCubit] Deleting error: $e');
      emit(MediaError('[MediasCubit] Deleting error: $e'));
    }
  }


  Future<void> refresh({required String token}) async {
    try {
      emit(const MediaLoading());
      final allMedias = await _mediaRepository.getAllMedia();
      emit(GetMediaSuccess(allMedias));
    } catch (e) {
      emit(MediaError('Refresh error: ${e.toString()}'));
    }
  }

  Future<void> refreshLocalOnly() async {
    try {
      final allMedias = await _mediaRepository.getAllMedia();
      emit(GetMediaSuccess(allMedias));
    } catch (e) {
      emit(MediaError('Local refresh error: ${e.toString()}'));
    }
  }

}

