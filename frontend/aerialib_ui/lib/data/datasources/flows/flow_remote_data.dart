import 'dart:convert';

import 'package:frontend/data/models/flow_model.dart';
import 'package:frontend/data/services/http_service.dart';
import 'package:uuid/uuid.dart';

class FlowRemoteDataSource {
  final HttpService httpService;

  FlowRemoteDataSource({required this.httpService});

  /// Create and return FlowModel
  Future<FlowModel> createFlow({
    required String name,
    required String description,
    required String apparatus,
    required String createdBy,
    required String token,
  }) async {

    final body = {
      'name': name,
      'description': description,
      'apparatus': apparatus,
      'createdBy': createdBy,
    };

    try {
      // first try POST into backend.
      final response = await httpService.post(
        path: "/flows",
        token: token,
        body: body,
      );

      return FlowModel.fromJson(response.body);

    } catch (e) {
      // Fallback: construct a local unsynced FlowModel
      return FlowModel(
        id: const Uuid().v6(),
        name: name,
        description: description,
        apparatus: apparatus,
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
    final List<Map<String, dynamic>> flowListInMap = flows.map((flow) => flow.toMap()).toList();
    print(flowListInMap);
    final response = await httpService.post(
      path: "/flows/sync",
      token: token,
      body: flowListInMap,
    );
    print(response);

    return response.statusCode == 201;
  }

  Future<FlowModel> updateFlow({
    required FlowModel updatedFlow,
    required String token,
  }) async {
    final response = await httpService.put(
      path: "/flows/update/${updatedFlow.id}",
      token: token,
      body: updatedFlow.toJson(),
    );

    return FlowModel.fromJson(response.body);
  }
}
