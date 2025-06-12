import 'dart:convert';
import 'dart:developer';
import 'package:uuid/uuid.dart';

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

  /// Sync flow poses: delete old and insert new for each flow
  Future<bool> syncFlowPoses({
    required String token,
    required Map<String, List<FlowPoseModel>> flowPoseMap,
  }) async {
    try {
      for (final entry in flowPoseMap.entries) {
        final flowId = entry.key;
        final poses = entry.value;

        // Step 1: Delete old flow poses
        final deleteSuccess = await deleteFlowPosesByFlowId(
          flowId: flowId,
          token: token,
        );

        if (!deleteSuccess) {
          log('[FlowPoseRemoteDataSource] Failed to delete old flow poses for flow $flowId');
          return false;
        }

        // Step 2: Create new flow poses
        final created = await createFlowPoses(
          flowPoses: poses,
          token: token,
        );

        if (created.length != poses.length) {
          log('[FlowPoseRemoteDataSource] Mismatch in synced flow poses count for flow $flowId');
          return false;
        }
      }

      log('[FlowPoseRemoteDataSource] All flow poses synced successfully');
      return true;
    } catch (e) {
      log('[FlowPoseRemoteDataSource] Sync error: $e');
      return false;
    }
  }
}
