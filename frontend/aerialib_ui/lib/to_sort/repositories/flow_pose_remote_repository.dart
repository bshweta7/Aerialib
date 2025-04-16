import 'dart:async';
import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/to_sort/repositories/flow_pose_local_repository.dart';
import 'package:frontend/to_sort/models/flow_pose_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class FlowPoseRemoteRepository {
  final flowPoseLocalRepository = FlowPoseLocalRepository();

  Future<FlowPoseModel> createFlowPose({
    required String flowId,
    required String poseId,
    required int order,
    required String transitionId,
    required String token,
  }) async {

    try {
      // First try POST into backend
      final res = await http.post(
          Uri.parse("${Constants.backendUri}/flow_poses"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'flowId': flowId,
            'poseId': poseId,
            'order': order,
            'transitionId': transitionId,
          })
      );

      if(res.statusCode != 201) {
        print("ERROR: Could not create pose --> POST /poses");
        throw jsonDecode(res.body)['error'];
      } else {
        return FlowPoseModel.fromJson(res.body);
      }

    } catch (e) {
      try {
        // otherwise make a PoseModel without POSTing it.
        final flowPoseModel = FlowPoseModel(
          id: const Uuid().v6(),
          flowId: flowId,
          poseId: poseId,
          order: order,
          transitionId: transitionId,
          isSynced: 0,
        );
        // await poseLocalRepository.insertPose(poseModel); // TODO shouldnt this insert???
        return flowPoseModel;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<List<FlowPoseModel>> getFlowPoses({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse("${Constants.backendUri}/flow_poses"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          }
      );

      if(res.statusCode != 200) {
        print("ERROR: Remote repository fetch error - GET /flow_poses");
        print(res.body);
        throw jsonDecode(res.body)['error'];
      }

      final remoteFlowPosesList = jsonDecode(res.body);

      List<FlowPoseModel> remoteFlowPosesListMapped = [];

      for (var element in remoteFlowPosesList) {
        remoteFlowPosesListMapped.add(FlowPoseModel.fromMap(element));
      }

      await flowPoseLocalRepository.insertFlowPoses(remoteFlowPosesListMapped);

      return remoteFlowPosesListMapped;
    } catch (e) {
      final flowPoses = await flowPoseLocalRepository.getFlowPoses();
      if (flowPoses.isNotEmpty) {
        return flowPoses;
      }
      rethrow; // same as throw (e)
    }
  }

  Future<bool> syncFlowPoses({
    required String token,
    required List<FlowPoseModel> flowPoses,

  }) async {
    try {
      final flowPoseListInMap = [];
      for (final flowPose in flowPoses) {
        flowPoseListInMap.add(flowPose.toMap());
      }
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/flow_poses/sync"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(flowPoseListInMap),
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


  Future<FlowPoseModel> updateFlowPose({
    required FlowPoseModel updatedFlowPose,
    required String token,
  }) async {
    try {
      final res = await http.put(
        Uri.parse("${Constants.backendUri}/flow_poses/update/${updatedFlowPose.id}"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(updatedFlowPose.toJson()), // Convert PoseModel to JSON
      );

      if (res.statusCode != 200) {
        print("ERROR: Could not update pose --> PUT /flow_poses/update/${updatedFlowPose.id}");
        throw jsonDecode(res.body)['error'];
      } else {
        return FlowPoseModel.fromJson(res.body);
      }
    } catch (e) {
      try {
        // Handle local update
        await flowPoseLocalRepository.updateFlowPose(updatedFlowPose);
        return updatedFlowPose;
      } catch (localUpdateError){
        rethrow;
      }
    }
  }

}