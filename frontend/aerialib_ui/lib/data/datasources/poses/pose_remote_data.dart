import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/data/models/pose_model.dart';
import 'package:uuid/uuid.dart';
import 'package:frontend/data/services/http_service.dart';

class PoseRemoteDataSource {
  final HttpService httpService;

  PoseRemoteDataSource({required this.httpService});

  /// Create and return PoseModel
  Future<PoseModel> createPose({
    required String name,
    required String apparatus,
    required double level,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    required String primaryImageId,
    required String createdBy,
    required String token,
  }) async {

    final body = {
      'name': name,
      'apparatus': apparatus,
      'level': level,
      'primaryImageId': primaryImageId,
      'createdBy': createdBy,
      if (description != null) 'description': description,
      if (teachingCues != null) 'teachingCues': teachingCues,
      if (safetyCues != null) 'safetyCues': safetyCues,
      if (progressions != null) 'progressions': progressions,
    };

    try {
      final response = await httpService.post(
        path: "/poses",
        token: token,
        body: body,
      );

      return PoseModel.fromJson(response.body);
    } catch (e) {
      // Fallback: construct a local unsynced PoseModel
      final now = DateTime.now();
      return PoseModel(
        id: const Uuid().v6(),
        name: name,
        primaryImageId: primaryImageId,
        apparatus: apparatus,
        level: level,
        description: description,
        teachingCues: teachingCues,
        safetyCues: safetyCues,
        progressions: progressions,
        createdBy: createdBy,
        updatedBy: createdBy,
        createdAt: now,
        updatedAt: now,
        isSynced: 0,
      );
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
    final List<Map<String, dynamic>> poseListInMap = poses.map((pose) => pose.toMap()).toList();
    print('[PoseRemoteDataSource] Sync payload:');
    poseListInMap.forEach((map) => print(map.keys));

    final response = await httpService.post(
      path: "/poses/sync",
      token: token,
      body: poseListInMap,
    );
    print(response);

    return response.statusCode == 201;
  }


  Future<PoseModel> updatePose({
    required PoseModel updatedPose,
    required String token,
  }) async {
    final response = await httpService.put(
      path: "/poses/update/${updatedPose.id}",
      token: token,
      body: updatedPose.toJson(),
    );

    return PoseModel.fromJson(response.body);
  }

  // TODO delete pose option
}
