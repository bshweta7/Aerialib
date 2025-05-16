import 'dart:convert';
import 'dart:developer';
import 'package:uuid/uuid.dart';

import 'package:frontend/data/models/flow_pose_model.dart';
import 'package:frontend/data/services/http_service.dart';


class FlowPoseRemoteDataSource {
  final HttpService httpService;

  FlowPoseRemoteDataSource({required this.httpService});

  /// Create and return FlowPoseModel
  Future<FlowPoseModel> createFlowPose({
    required String flowId,
    required String poseId,
    required int poseOrder,
    String? transitionId,
    required String token,
  }) async {
    final body = {
      'flow_id': flowId,
      'pose_id': poseId,
      'pose_order': poseOrder,
      if (transitionId != null) 'transition_id': transitionId,
    };

    try {
      final response = await httpService.post(
        path: "/flow_poses",
        token: token,
        body: body,
      );

      return FlowPoseModel.fromJson(response.body);
    } catch (e) {
      // Fallback: construct a local unsynced FlowPoseModel
      return FlowPoseModel(
        id: const Uuid().v6(),
        flowId: flowId,
        poseId: poseId,
        poseOrder: poseOrder,
        transitionId: transitionId,
        isSynced: 0,
      );
    }
  }

  /// Retrieve all FlowPoseModels from remote
  Future<List<FlowPoseModel>> fetchRemoteFlowPoses({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/flow_poses",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => FlowPoseModel.fromMap(e)).toList();
  }

  /// Delete all the flow poses for a given flowId
  Future<void> deleteAllFlowPosesInFlow(String flowId, String token) async {
    final response = await httpService.delete(
      path: "/flow_poses/delete_all/$flowId",
      token: token,
    );

    if (response.statusCode == 200) {
      log("[FlowPoseRemoteDataSource] Deleted all flow poses for $flowId");
    } else {
      throw Exception("Failed to delete remote flow poses for $flowId");
    }
  }

  /// Sync local flow poses to remote
  Future<bool> syncFlowPoses({
    required String token,
    required List<FlowPoseModel> flowPoses,
  }) async {
    final flowPoseListInMap = flowPoses.map((pose) {
      final map = pose.toMap();
      map.remove('is_synced');
      return map;
    }).toList();

    // log('[FlowPoseRemoteDataSource] Sync payload:');
    // for (final map in flowPoseListInMap) {
    //   log(map.keys);
    // }

    log("[FlowPoseRemoteDataSource] $flowPoseListInMap");

    final response = await httpService.post(
      path: "/flow_poses/sync",
      token: token,
      body: flowPoseListInMap,
    );

    log('[FlowPoseRemoteDataSource] Status Code: ${response.statusCode}');
    log('[FlowPoseRemoteDataSource] Response Body: ${response.body}');

    if (response.statusCode == 201) {
      log('[FlowPoseRemoteDataSource] Sync successful');
      return true;
    } else {
      log('[FlowPoseRemoteDataSource] Sync failed');
      return false;
    }
  }

  /// Update a flow pose remotely
  Future<FlowPoseModel> updateFlowPose({
    required FlowPoseModel updatedFlowPose,
    required String token,
  }) async {
    final response = await httpService.put(
      path: "/flow_poses/update/${updatedFlowPose.id}",
      token: token,
      body: updatedFlowPose.toJson(),
    );

    return FlowPoseModel.fromJson(response.body);
  }
}
