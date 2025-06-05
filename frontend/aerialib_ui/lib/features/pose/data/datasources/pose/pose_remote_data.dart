import 'dart:developer';
import 'dart:convert';

import 'package:frontend/features/pose/data/models/pose_model.dart';
import 'package:frontend/core/services/http_service.dart';

class PoseRemoteDataSource {
  final HttpService httpService;

  PoseRemoteDataSource({required this.httpService});

  /// Create and return PoseModel
  Future<PoseModel> createPose({
    required PoseModel pose,
    required String token,
  }) async {
    try {
      final response = await httpService.post(
        path: "/poses",
        token: token,
        body: pose.toMapRemote(),
      );

      return PoseModel.fromJson(response.body);
    } catch (e) {
      return pose.copyWith(isSynced: 0); // fallback if server call fails
    }
  }

  Future<List<PoseModel>> fetchRemotePoses({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/poses",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => PoseModel.fromMap(e)).toList();
  }

  Future<bool> syncPoses({
    required String token,
    required List<PoseModel> poses,
  }) async {
    final poseListInMap = poses.map((pose) {
      final map = pose.toMap();
      map.remove('is_synced'); // TODO dont need this with the new toMapCamel
      map.remove('primary_media_path');
      log("MEDIA: ${pose.primaryMediaId}");
      return map;
    }).toList();

    log('[PoseRemoteDataSource] Sync payload:');
    for (final map in poseListInMap) {
      log('[PoseRemoteDataSource] ${map.keys}');
    }

    final response = await httpService.post(
      path: "/poses/sync",
      token: token,
      body: poseListInMap,
    );

    // log('[PoseRemoteDataSource] Sync response status: ${response.statusCode}');
    // log('[PoseRemoteDataSource] Sync response body: ${response.body}');

    if (response.statusCode == 201) {
      log('[PoseRemoteDataSource] Sync successful');
      return true;
    } else {
      log('[PoseRemoteDataSource] Sync failed');
      return false;
    }
  }


  Future<PoseModel> updatePose({
    required PoseModel updatedPose,
    required String token,
  }) async {
    final response = await httpService.put(
      path: "/poses/update/${updatedPose.id}",
      token: token,
      body: updatedPose.toMap(), // or explicit map
    );
    // log("____________________");
    //
    // log("Backend response body: ${response.body}");

    if (response.statusCode != 200) {
      log("[PoseRemoteDataSource] Failed to update pose:");
      log("[PoseRemoteDataSource] Status: ${response.statusCode}");
      log("[PoseRemoteDataSource] Body: ${response.body}");
      throw Exception("[PoseRemoteDataSource] Failed to update pose remotely");
    }

    final json = jsonDecode(response.body);
    return PoseModel.fromMap(json);
  }


// TODO delete pose option
}
