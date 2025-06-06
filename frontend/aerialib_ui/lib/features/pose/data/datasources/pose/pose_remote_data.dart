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

      final createdPose = PoseModel.fromJson(response.body);
      return createdPose.copyWith(isSynced: 1);

    } catch (e) {
      // Fallback: return original pose marked as not synced
      return pose.copyWith(isSynced: 0);
    }
  }

  /// Get all poses from remote database
  Future<List<PoseModel>> getRemotePoses({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/poses",
      token: token,
    );
    final decoded = jsonDecode(response.body);
    log('[PoseRemoteDataSource] Raw response: $decoded');

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => PoseModel.fromMap(e).copyWith(isSynced: 1)).toList();
  }

  /// Sync poses from local to remote
  Future<bool> syncPoses({
    required String token,
    required List<PoseModel> poses,
  }) async {
    final poseListInMap = poses.map((pose) => pose.toMapRemote()).toList();

    log('[PoseRemoteDataSource] Syncing ${poseListInMap.length} poses...');
    for (final map in poseListInMap) {
      log('[PoseRemoteDataSource] Syncing pose slug: ${map['slug']}');
    }

    final response = await httpService.post(
      path: "/poses/sync",
      token: token,
      body: poseListInMap,
    );

    if (response.statusCode == 201) {
      log('[PoseRemoteDataSource] Sync successful');
      return true;
    } else {
      log('[PoseRemoteDataSource] Sync failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  /// Update one pose
  Future<PoseModel> updatePose({
    required PoseModel updatedPose,
    required String token,
  }) async {
    final body = updatedPose.toMapRemote(); // uses camelCase and omits local-only fields

    final response = await httpService.put(
      path: "/poses/update/${updatedPose.id}",
      token: token,
      body: body,
    );

    if (response.statusCode != 200) {
      log("[PoseRemoteDataSource] Failed to update pose, status ${response.statusCode}");
      log("[PoseRemoteDataSource] Body: ${response.body}");
      throw Exception("[PoseRemoteDataSource] Failed to update pose remotely");
    }

    final json = jsonDecode(response.body);
    log("[PoseRemoteDataSource] Pose updated successfully: ${updatedPose.id}");
    return PoseModel.fromMap(json);
  }

  /// Delete a pose
  Future<void> deletePose({
    required String poseId,
    required String token,
  }) async {
    final response = await httpService.delete(
      path: "/poses/$poseId",
      token: token,
    );

    if (response.statusCode != 200) {
      log("[PoseRemoteDataSource] Failed to delete pose, status ${response.statusCode}");
      log("[PoseRemoteDataSource] Body: ${response.body}");
      throw Exception("[PoseRemoteDataSource] Failed to delete pose remotely");
    }

    log("[PoseRemoteDataSource] Pose deleted successfully: $poseId");
  }
}
