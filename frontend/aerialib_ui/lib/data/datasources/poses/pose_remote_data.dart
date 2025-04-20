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
    required String description,
    required String cues,
    required String apparatus,
    required int level,
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
    };

    try {
      // first try POST into backend.
      final response = await httpService.post(
        path: "/poses",
        token: token,
        body: body,
      );

      return PoseModel.fromJson(response.body);

    } catch (e) {
      // Fallback: construct a local unsynced PoseModel (but leave inserting to PoseRepository)
      return PoseModel(
        id: const Uuid().v6(),
        name: name,
        description: description,
        cues: cues,
        apparatus: apparatus,
        level: level,
        createdBy: createdBy,
        updatedBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: 0,
        primaryImageId: primaryImageId,
        primaryImageUrl: Constants.missingImageUrl, // TODO remove this (Note: This will update in backend but is required here because it is a required field in PoseModel)
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
    print(poseListInMap);
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
}
