import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:frontend/data/models/media_model.dart';
import 'package:frontend/data/services/http_service.dart';


class MediaRemoteDataSource {
  final HttpService httpService;

  MediaRemoteDataSource({required this.httpService});

  Future<MediaModel> createMedia({
    required String path,
    required String type,
    int? fileSize,
    String? primaryMedia,
    String? name,
    String? description,
    String? apparatus,
    required String uploadedBy,
    required String token,
  }) async {
    final body = {
      'mediaPath': path,
      'mediaType': type,
      if (fileSize != null) 'fileSize': fileSize,
      if (primaryMedia != null) 'primaryMedia': primaryMedia,
      if (name != null) 'name': name, // TODO generate name based on user uploading and date?
      if (description != null) 'description': description,
      if (apparatus != null) 'apparatus': apparatus,
      'uploadedBy': uploadedBy,
    };

    try {
      // POST to backend
      final response = await httpService.post(
        path: "/media",
        token: token,
        body: body,
      );

      return MediaModel.fromJson(response.body);

    } catch (e) {
      // Fallback: construct local unsynced MediaModel
      return MediaModel(
        id: const Uuid().v6(),
        path: path,
        type: type,
        fileSize: fileSize,
        primaryMedia: primaryMedia,
        name: name,
        description: description,
        apparatus: apparatus,
        uploadedBy: uploadedBy,
        uploadedAt: DateTime.now(),
        isSynced: 0,
      );
    }
  }


  Future<List<MediaModel>> fetchRemoteMediaList({ // TODO refactored from getMediaList
    required String token,
  }) async {
    print("[MediaRemoteDataSource] Sending GET request... ");
    final response = await httpService.get(
      path: "/media",
      token: token,
    );

    print("[MediaRemoteDataSource] Mapping response to MediaModel... ");
    final List<dynamic> jsonList = jsonDecode(response.body);

    for (var e in jsonList) {
      try {
        print("Mapping: $e");
        final media = MediaModel.fromMap(e);
        // Optionally print media to confirm success
      } catch (error, stack) {
        print("Failed to map media: $e");
        print("Error: $error");
        print("Stack: $stack");
        rethrow; // Optional: or return a fallback
      }
    }


    return jsonList.map((e) => MediaModel.fromMap(e)).toList();
  }

  /// Sync local media entries to the remote data source
  Future<bool> syncMedia({
    required String token,
    required List<MediaModel> mediaList,
  }) async {
    final List<Map<String, dynamic>> mediaListInMap = mediaList.map((media) {
      final map = media.toMap();
      map.remove('is_synced');
      return map;
    }).toList();

    print('[MediaRemoteDataSource] Sync payload:');
    for (final map in mediaListInMap) {
      print(map.keys);
    }

    print(mediaListInMap);

    final response = await httpService.post(
      path: "/media/sync",
      token: token,
      body: mediaListInMap,
    );

    print('[MediaRemoteDataSource] Status Code: ${response.statusCode}');
    print('[MediaRemoteDataSource] Response: ${response.body}');

    return response.statusCode == 201;
  }

  Future<MediaModel> updateMedia({
    required MediaModel updatedMedia,
    required String token,
  }) async {
    final response = await httpService.put(
      path: "/media/update/${updatedMedia.id}",
      token: token,
      body: updatedMedia.toJson(),
    );

    return MediaModel.fromJson(response.body);
  }

}