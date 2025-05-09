import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/data/datasources/media/media_remote_data.dart';
import 'package:frontend/data/datasources/media/media_local_data.dart';
import 'package:frontend/data/models/media_model.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/media_entity.dart';
import 'package:frontend/domain/repositories/media_repository.dart';

import '../../../domain/repositories/media_repository.dart';

// TODO note - maybe I shouldn't combine the mediaURL into this and instead call it separately - see what makes sense...
// TODO - If syncRemoteToLocal or syncLocalToRemote can fail (e.g., due to network issues), you might want to handle those errors more gracefully (maybe show a snackbar or a retry button) in the UI. We have an optional MediaError state to handle those errors.
// TODO - The syncMedias method has been modified to first sync local unsynced medias and then sync remote medias back to local. You might want to consider handling the case where network is unavailable or when some medias are not synced successfully.


part 'media_state.dart';



class MediaCubit extends Cubit<MediaState>{
  final MediaRepository _mediaRepository;
  bool _isSyncing = false;

  MediaCubit(this._mediaRepository) : super(const MediaInitial());

  /// Create a new media
  Future<void> createNewMedia({
    required String path,
    String? name,
    String? description,
    String? apparatus,
    String? primaryMedia, // e.g. 'pose', 'flow', etc.
    required String uploadedBy,
    required String token,
  }) async {
    try {
      emit(const MediaLoading());

      final media = await _mediaRepository.createMedia(
        path: path,
        name: name ?? '',
        description: description ?? '',
        apparatus: apparatus ?? '',
        uploadedBy: uploadedBy,
        token: token,
        primaryMedia: primaryMedia,
      );

      emit(AddNewMediaSuccess(media));
    } catch (e) {
      print("Error creating media: $e");
      emit(MediaError(e.toString()));
    }
  }


  /// Fetch all medias (from local storage or remote if needed)
  Future<void> getAllMedia({required String token}) async {
    try {
      print("Fetching medias...");
      emit(const MediaLoading());

      List<MediaEntity> medias = await _mediaRepository.getLocalMedias();  // Fetch local medias
      if (medias.isEmpty) {
        // If no local medias, sync from remote and retry
        print("[MediaCubit] No medias in local datasource, syncing from remote");
        await _mediaRepository.syncRemoteToLocal(token);

        medias = await _mediaRepository.getLocalMedias();
      }

      print("[MediaCubit] Number of Medias Retrieved: ${medias.length}");
      emit(GetMediaSuccess(medias));

    } catch (e) {
      print("[MediaCubit] Cubit GetAllMedia failed");
      print(e.toString());
      emit(MediaError(e.toString()));
    }
  }

  /// Sync medias (sync unsynced local medias with remote)
  Future<void> syncMedia({required String token}) async {
    if (_isSyncing) return;
    _isSyncing = true;

    print("[MediaCubit] Starting one-shot sync of flow poses...");

    try {
      await _mediaRepository.syncLocalToRemote(token);
      print('[MediaCubit] Synced local to remote.');

      await _mediaRepository.syncRemoteToLocal(token);
      print('[MediaCubit] Synced remote to local.');

      // final updatedFlows = await _flowPoseRepository.getAllFlowPoses();
      // emit(GetFlowsSuccess(updatedFlows));
    } catch (e) {
      print('[MediaCubit] Sync error: $e');
      emit(MediaError('[MediaCubit] Sync error: $e'));
    } finally {
      _isSyncing = false;
    }
  }
}

