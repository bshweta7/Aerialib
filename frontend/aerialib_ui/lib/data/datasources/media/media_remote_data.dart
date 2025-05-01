import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:frontend/data/models/media_model.dart';
import 'package:frontend/data/services/http_service.dart';


class MediaRemoteDataSource {
  final HttpService httpService;

  MediaRemoteDataSource({required this.httpService});
  
  Future<MediaModel> createMedia({
    required String mediaPath,
    required String mediaType,
    int? fileSize,
    String? primaryMedia,
    String? name,
    String? description,
    String? apparatus,
    required String uploadedBy,
    required String token,
  }) async {
    final body = {
      'media_path': mediaPath,
      'media_type': mediaType,
      if (fileSize != null) 'file_size': fileSize,
      if (primaryMedia != null) 'primary_media': primaryMedia,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (apparatus != null) 'apparatus': apparatus,
      'uploaded_by': uploadedBy,
    };

    try {
      // First try POST into backend
      final response = await httpService.post(
        path: "/media",
        token: token,
        body: body,
      );

      return MediaModel.fromJson(response.body);

    } catch (e) {
      // Fallback: construct a local unsynced MediaModel (but leave inserting to MediaRepository)
      return MediaModel(
        id: const Uuid().v6(),
        path: mediaPath,
        type: mediaType,
        fileSize: fileSize,
        primaryMedia: primaryMedia,
        name: name ?? '',
        description: description ?? '',
        apparatus: apparatus ?? '',
        uploadedBy: uploadedBy,
        uploadedAt: DateTime.now(),
        isSynced: 0,
      );
    }
  }


  Future<List<MediaModel>> fetchRemoteMediaList({ // TODO refactored from getMediaList
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/media",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => MediaModel.fromMap(e)).toList();
  }

  Future<bool> syncMedia({
    required String token,
    required List<MediaModel> mediaList,
  }) async {
    final List<Map<String, dynamic>> mediaListInMap = mediaList.map((media) => media.toMap()).toList();
    print(mediaListInMap);
    final response = await httpService.post(
      path: "/media/sync",
      token: token,
      body: mediaListInMap,
    );
    print(response);

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