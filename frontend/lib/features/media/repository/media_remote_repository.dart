import 'dart:async';
import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/media/repository/media_local_repository.dart';
import 'package:frontend/models/media_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class MediaRemoteRepository {
  final mediaLocalRepository = MediaLocalRepository();

  Future<MediaModel> createMedia({
    required String mediaURL,
    required String name,
    required String description,
    required String apparatus,
    required String uploadedBy,
    required String token,

  }) async {

    try {
      // First try POST into backend
      final res = await http.post(
          Uri.parse("${Constants.backendUri}/media"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'mediaURL': mediaURL,
            'name': name,
            'description': description,
            'apparatus': apparatus,
            'uploadedBy': uploadedBy,
          })
      );

      if(res.statusCode != 201) {
        print("ERROR: Could not create media --> POST /media");
        throw jsonDecode(res.body)['error'];
      } else {
        return MediaModel.fromJson(res.body);
      }

    } catch (e) {
      try {
        // otherwise make a MediaModel without POSTing it.
        final mediaModel = MediaModel(
          id: const Uuid().v6(),
          mediaURL: mediaURL,
          name: name,
          description: description,
          apparatus: apparatus,
          uploadedBy: uploadedBy,
          uploadedAt: DateTime.now(),
          isSynced: 0,

        );
        // await mediaLocalRepository.insertMedia(mediaModel); // TODO shouldnt this insert???
        return mediaModel;
      } catch (e) {
        rethrow;
      }
    }
  }


  Future<List<MediaModel>> getMediaList({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse("${Constants.backendUri}/media"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          }
      );

      if(res.statusCode != 200) {
        print("ERROR: Remote repository fetch error - GET /media");
        // print(res.body);
        throw jsonDecode(res.body)['error'];
      }

      final remoteMediaList = jsonDecode(res.body);
      List<MediaModel> remoteMediaListMapped = [];

      for (var element in remoteMediaList) {
        remoteMediaListMapped.add(MediaModel.fromMap(element));
      }

      await mediaLocalRepository.insertMediaList(remoteMediaListMapped);

      return remoteMediaListMapped;
    } catch (e) {
      final mediaList = await mediaLocalRepository.getMediaList();
      if (mediaList.isNotEmpty) {
        return mediaList;
      }
      rethrow; // same as throw (e)
    }
  }

  Future<bool> syncMedia({
    required String token,
    required List<MediaModel> mediaList,

  }) async {
    try {
      final mediaListInMap = [];
      for (final media in mediaList) {
        mediaListInMap.add(media.toMap());
      }
      print("TEST");
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/media/sync"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(mediaListInMap),
      );

      if(res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

}