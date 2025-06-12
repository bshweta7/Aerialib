import 'dart:convert';
import 'dart:developer';

import 'package:uuid/uuid.dart';
import 'package:frontend/features/flow/data/models/flow_model.dart';
import 'package:frontend/core/services/http_service.dart';

class FlowRemoteDataSource {
  final HttpService httpService;

  FlowRemoteDataSource({required this.httpService});

  /// Create and return FlowModel
  Future<FlowModel> createFlow({
    required FlowModel flow,
    required String token,
  }) async {
    try {
      final response = await httpService.post(
        path: "/flows",
        token: token,
        body: flow.toMapRemote(),
      );

      final createdFlow = FlowModel.fromJson(response.body);
      return createdFlow.copyWith(isSynced: 1);

    } catch (e) {
      // Fallback: return original flow marked as not synced
      return flow.copyWith(isSynced: 0);
    }
  }

  /// Get all flows from remote database
  Future<List<FlowModel>> getRemoteFlows({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/flows",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList
        .map((e) => FlowModel.fromMap(e).copyWith(isSynced: 1))
        .toList();
  }

  /// Sync flows from local to remote
  Future<bool> syncFlows({
    required String token,
    required List<FlowModel> flows,
  }) async {
    final flowListInMap = flows.map((flow) => flow.toMapRemote()).toList();

    log('[FlowRemoteDataSource] Syncing ${flowListInMap.length} flows...');

    final response = await httpService.post(
      path: "/flows/sync",
      token: token,
      body: flowListInMap,
    );

    if (response.statusCode == 201) {
      log('[FlowRemoteDataSource] Sync successful');
      return true;
    } else {
      log('[FlowRemoteDataSource] Sync failed: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  /// Delete a flow
  Future<void> deleteFlow({
    required String flowId,
    required String token,
  }) async {
    final response = await httpService.delete(
      path: "/flows/delete/$flowId",
      token: token,
    );

    if (response.statusCode != 200) {
      log("[FlowRemoteDataSource] Failed to delete flow, status ${response.statusCode}");
      log("[FlowRemoteDataSource] Body: ${response.body}");
      throw Exception("[FlowRemoteDataSource] Failed to delete flow remotely");
    }

    log("[FlowRemoteDataSource] Flow deleted successfully: $flowId");
  }
}
