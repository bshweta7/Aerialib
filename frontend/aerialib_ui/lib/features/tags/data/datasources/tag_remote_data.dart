import 'dart:convert';
import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:frontend/features/tags/data/models/tag_model.dart';
import 'package:frontend/core/services/http_service.dart';

class TagRemoteDataSource {
  final HttpService httpService;

  TagRemoteDataSource({required this.httpService});

  /// Create a new tag remotely
  Future<TagModel> createTag({
    required String name,
    String? color,
    required String createdBy,
    required String token,
  }) async {
    final body = {
      'name': name,
      if (color != null) 'color': color,
      'created_by': createdBy,
    };

    try {
      final response = await httpService.post(
        path: "/tags",
        token: token,
        body: body,
      );

      log("[TagRemoteDataSource] Created tag: ${response.body}");
      return TagModel.fromMap(jsonDecode(response.body));
    } catch (e) {
      log("[TagRemoteDataSource] Failed to create tag: $e");

      return TagModel(
        id: const Uuid().v6(),
        userId: createdBy,
        name: name,
        color: color,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: 0,
      );
    }
  }

  /// Fetch tags for the user and admin
  Future<List<TagModel>> fetchRemoteTags({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/tags",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => TagModel.fromMap(e)).toList();
  }

  /// Delete a tag by ID
  Future<void> deleteTagById(String tagId, String token) async {
    final response = await httpService.delete(
      path: "/tags/$tagId",
      token: token,
    );

    if (response.statusCode == 200) {
      log("[TagRemoteDataSource] Deleted tag with ID $tagId");
    } else {
      throw Exception("Failed to delete tag with ID $tagId");
    }
  }

  /// Update an existing tag
  Future<TagModel> updateTag({
    required TagModel updatedTag,
    required String token,
  }) async {
    final response = await httpService.put(
      path: "/tags/update/${updatedTag.id}",
      token: token,
      body: updatedTag.toMap(),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update tag with ID ${updatedTag.id}");
    }

    return TagModel.fromMap(jsonDecode(response.body));
  }

  /// Sync a list of tags to the backend
  Future<bool> syncTags({
    required String token,
    required List<TagModel> tags,
  }) async {
    final payload = tags.map((tag) {
      final map = tag.toMap();
      map.remove('is_synced');
      return map;
    }).toList();

    final response = await httpService.post(
      path: "/tags/sync",
      token: token,
      body: payload,
    );

    return response.statusCode == 201;
  }
}
