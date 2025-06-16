import 'dart:convert';
import 'dart:developer';

import 'package:frontend/features/flow/data/models/flow_pose_model.dart';
import 'package:frontend/core/services/http_service.dart';


class FlowPoseRemoteDataSource {
  final HttpService httpService;

  FlowPoseRemoteDataSource({required this.httpService});

  /// Create multiple flow poses and return synced versions
  Future<List<FlowPoseModel>> createFlowPoses({
    required List<FlowPoseModel> flowPoses,
    required String token,
  }) async {
    try {
      final body = flowPoses.map((fp) => fp.toMapRemote()).toList();

      final response = await httpService.post(
        path: "/flow_poses",
        token: token,
        body: body,
      );

      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((e) => FlowPoseModel.fromMap(e).copyWith(isSynced: 1))
          .toList();
    } catch (e) {
      // Fallback: return original list marked as not synced
      return flowPoses.map((fp) => fp.copyWith(isSynced: 0)).toList();
    }
  }

  /// Get all flow poses for flows created by the user or admin
  Future<List<FlowPoseModel>> getRemoteFlowPoses({
    required String token,
  }) async {
    try {
      final response = await httpService.get(
        path: "/flow_poses",
        token: token,
      );

      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((e) => FlowPoseModel.fromMap(e).copyWith(isSynced: 1))
          .toList();
    } catch (e) {
      // On failure, return empty list or optionally rethrow
      return [];
    }
  }

  /// Delete all flow poses for a given flow ID
  Future<bool> deleteFlowPosesByFlowId({
    required String flowId,
    required String token,
  }) async {
    final response = await httpService.delete(
      path: "/flow_poses/delete/$flowId",
      token: token,
    );

    if (response.statusCode == 200) {
      log("[FlowPoseRemoteDataSource] Flow poses deleted for flow: $flowId");
      return true;
    } else {
      log("[FlowPoseRemoteDataSource] Failed to delete flow poses: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  /// Delete all flow poses for a given flow ID
  Future<bool> deleteFlowPose({
    required String flowPoseId,
    required String token,
  }) async {
    final response = await httpService.delete(
      path: "/flow_poses/delete/pose/$flowPoseId",
      token: token,
    );

    if (response.statusCode == 200) {
      log("[FlowPoseRemoteDataSource] Flow pose deleted: $flowPoseId");
      return true;
    } else {
      log("[FlowPoseRemoteDataSource] Failed to delete flow pose: ${response.statusCode} - ${response.body}");
      return false;
    }
  }

  /// Sync flow poses: delete old and insert new for each flow
  Future<bool> syncFlowPoses({
    required String token,
    required List<FlowPoseModel> flowPoses,
  }) async {
    final flowPoseListInMap = flowPoses.map((fp) => fp.toMapRemote()).toList();

    // ✅ Collect ALL ids, even if they might not exist on the backend
    final idsToDelete = flowPoses
        .map((fp) => fp.id)
        .where((id) => id.isNotEmpty)
        .toList();

    if (idsToDelete.isNotEmpty) {
      final deleteResponse = await httpService.delete(
        path: "/flow_poses",
        token: token,
        body: { 'ids': idsToDelete },
      );

      if (deleteResponse.statusCode != 200) {
        log('[FlowPoseRemoteDataSource] Delete failed: ${deleteResponse.statusCode} - ${deleteResponse.body}');
        return false;
      }
    }

    final insertResponse = await httpService.post(
      path: "/flow_poses",
      token: token,
      body: flowPoseListInMap,
    );

    if (insertResponse.statusCode == 201) {
      log('[FlowPoseRemoteDataSource] Sync successful');
      return true;
    } else {
      log('[FlowPoseRemoteDataSource] Insert failed: ${insertResponse.statusCode} - ${insertResponse.body}');
      return false;
    }
  }
}
