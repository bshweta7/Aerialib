import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/data/datasources/media/media_remote_data.dart';
import 'package:frontend/data/datasources/media/media_local_data.dart';
import 'package:frontend/to_sort/models/media_model.dart';

part 'media_state.dart';

class MediaCubit extends Cubit<MediaState>{
  MediaCubit() : super(MediaInitial());
  final mediaRemoteRepository = MediaRemoteDataSource();
  final mediaLocalRepository = MediaLocalDataSource();

  Future<void> createNewMedia({
    required String mediaURL, // TODO Change to path OR MEDIAPATH
    required String name,
    required String description,
    required String apparatus,
    required String uploadedBy,
    required String token,
  }) async {
    try {
      emit(MediaLoading());
      final mediaModel = await mediaRemoteRepository.createMedia(
        mediaPath: mediaURL,
        name: name,
        description: description,
        apparatus: apparatus,
        uploadedBy: uploadedBy,
        token: token,
      );
      await mediaLocalRepository.insertMedia(mediaModel); // TODO isSynced = 0 when remote failed - is this defined?

      emit(AddNewMediaSuccess(mediaModel));
    } catch (e) {
      print(e.toString());
      emit(MediaError(e.toString()));
    }
  }

  Future<void> getAllMedia({required String token,
  }) async {
    try {
      emit(MediaLoading());
      final mediaList = await mediaRemoteRepository.getMediaList(token: token);

      emit(GetMediaListSuccess(mediaList));

    } catch (e) {
      print(e.toString());
      emit(MediaError(e.toString()));
    }
  }

  Future<void> syncMedia(String token) async {
    // get all unsynced media from our sqlite db
    final unsyncedMedia = await mediaLocalRepository.getUnsyncedMedia();
    print(unsyncedMedia);
    if (unsyncedMedia.isEmpty) {
      return;
    }
    // talk to our postgresql db to add the new media
    final isSynced = await mediaRemoteRepository.syncMedia(
        token: token,
        mediaList: unsyncedMedia
    );
    // change the media rows that were added to the db from 0 to 1
    if (isSynced) {
      print("Unsynced media have been synced");
      for (final media in unsyncedMedia) {
        mediaLocalRepository.setSyncedStatus(media.id, 1);
      }
    }

  }
}

// TODO see his next video on background plugin that syncs every 7 days.
