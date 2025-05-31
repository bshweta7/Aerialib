import 'dart:convert';
import 'dart:developer';

import 'package:uuid/uuid.dart';
import 'package:frontend/data/models/flow_model.dart';
import 'package:frontend/core/services/http_service.dart';

class FlowRemoteDataSource {
  final HttpService httpService;

  FlowRemoteDataSource({required this.httpService});

  /// Create and return FlowModel
  Future<FlowModel> createFlow({
    required String name,
    required String thumbnailImageId,
    required String thumbnailImagePath,
    required String apparatus,
    required double level,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    required String createdBy,
    required String token,
  }) async {
    final body = {
      'name': name,
      'thumbnail_image_id': thumbnailImageId,
      'apparatus': apparatus,
      'level': level,
      if (description != null) 'description': description,
      if (teachingCues != null) 'teaching_cues': teachingCues,
      if (safetyCues != null) 'safety_cues': safetyCues,
      if (progressions != null) 'progressions': progressions,
      'created_by': createdBy,
    };

    try {
      final response = await httpService.post(
        path: "/flows",
        token: token,
        body: body,
      );

      log("[RemoteDataSource] Flow created remotely: ${response.body}");
      return FlowModel.fromJson(response.body);
    } catch (e) {
      log("[RemoteDataSource] Failed to create flow remotely: $e");
      log("[RemoteDataSource] Creating local fallback unsynced flow instead.");
      // Fallback: construct a local unsynced FlowModel
      return FlowModel(
        id: const Uuid().v6(),
        name: name,
        thumbnailImageId: thumbnailImageId,
        thumbnailImagePath: thumbnailImagePath,
        apparatus: apparatus,
        level: level,
        description: description,
        teachingCues: teachingCues,
        safetyCues: safetyCues,
        progressions: progressions,
        createdBy: createdBy,
        updatedBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: 0,
      );
    }
  }

  /// Retrieve flows from remote data source and return list of FlowModels
  Future<List<FlowModel>> fetchRemoteFlows({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/flows",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => FlowModel.fromMap(e)).toList();
  }

  /// Sync local flows to remote data source
  Future<bool> syncFlows({
    required String token,
    required List<FlowModel> flows,
  }) async {
    final List<Map<String, dynamic>> flowListInMap = flows.map((flow) {
      final map = flow.toMap();
      map.remove('is_synced');
      map.remove('thumbnail_image_path');
      return map;
    }).toList();

    log('[FlowRemoteDataSource] Sync payload: $flowListInMap');
    // for (final map in flowListInMap) {
    //   log(map['name']);
    // }

    // log(flowListInMap);

    final response = await httpService.post(
      path: "/flows/sync",
      token: token,
      body: flowListInMap,
    );

    return response.statusCode == 201;
  }

  Future<FlowModel> updateFlow({
    required FlowModel updatedFlow,
    required String token,
  }) async {
    log("[FlowRemoteDataSource] ${jsonEncode(updatedFlow.toMap())}");

    final response = await httpService.put(
      path: "/flows/update/${updatedFlow.id}",
      token: token,
      body: updatedFlow.toMap(),
    );

    log("[FlowRemoteDataSource] Backend response body: ${response.body}");
    log("[FlowRemoteDataSource] Backend response status code: ${response.statusCode}");

    if (response.statusCode != 200) {
      log("[FlowRemoteDataSource] Failed to update flow:");
      log("[FlowRemoteDataSource] Status: ${response.statusCode}");
      log("[FlowRemoteDataSource] Body: ${response.body}");
      throw Exception("[FlowRemoteDataSource] Failed to update flow remotely");
    }

    final json = jsonDecode(response.body);
    return FlowModel.fromMap(json);
  }

  /// Delete all the flow poses for a given flowId
  Future<void> deleteFlowById(String flowId, String token) async {
    final response = await httpService.delete(
      path: "/flows/$flowId",
      token: token,
    );

    if (response.statusCode == 200) {
      log("[FlowRemoteDataSource] Deleted flow with flow ID $flowId");
    } else {
      throw Exception("Failed to delete remote flow with ID $flowId");
    }
  }
}
