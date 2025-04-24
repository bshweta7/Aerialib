import 'dart:convert';

import 'package:frontend/data/models/flow_pose_model.dart';
import 'package:frontend/data/services/http_service.dart';
import 'package:uuid/uuid.dart';

class FlowPoseRemoteDataSource {
  final HttpService httpService;

  FlowPoseRemoteDataSource({required this.httpService});

  /// Create and return FlowModel
  Future<FlowPoseModel> createFlowPose({
    required String flowId,
    required String poseId,
    required int order,
    required String transitionId,
    required String token,
  }) async {

    final body = {
      'flowId': flowId,
      'poseId': poseId,
      'order': order,
      'transitionId': transitionId,
    };

    try {
      // first try POST into backend.
      final response = await httpService.post(
        path: "/flow_poses",
        token: token,
        body: body,
      );

      return FlowPoseModel.fromJson(response.body);

    } catch (e) {
      // Fallback: construct a local unsynced FlowModel
      return FlowPoseModel(
        id: const Uuid().v6(),
        flowId: flowId,
        poseId: poseId,
        order: order,
        transitionId: transitionId,
        isSynced: 0,
      );
    }
  }

  /// Retrieve flow poses from remote data source and return list of FlowPoseModels
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


  /// Sync local flows to remote data source
  Future<bool> syncFlowPoses({
    required String token,
    required List<FlowPoseModel> flowPoses,
  }) async {
    final List<Map<String, dynamic>> flowPoseListInMap = flowPoses.map((flowPose) => flowPose.toMap()).toList();
    print(flowPoseListInMap);
    final response = await httpService.post(
      path: "/flow_poses/sync",
      token: token,
      body: flowPoseListInMap,
    );
    print(response);

    return response.statusCode == 201;
  }

  /// Update flow pose
  /// /// TODO might not need this
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
