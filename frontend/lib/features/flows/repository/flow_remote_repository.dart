import 'dart:async';
import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/flows/repository/flow_local_repository.dart';
import 'package:frontend/models/flow_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class FlowRemoteRepository {
  final flowLocalRepository = FlowLocalRepository();

  Future<FlowModel> createFlow({
    required String name,
    required String description,
    required String apparatus,
    required String primaryImageId,
    required String token,
    required String createdBy,
  }) async {

    try {
      // First try POST into backend
      final res = await http.post(
          Uri.parse("${Constants.backendUri}/flows"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'name': name,
            'description': description,
            'apparatus': apparatus,
            'createdBy': createdBy,
            'primaryImageId': primaryImageId,
          })
      );

      if(res.statusCode != 201) {
        print("ERROR: Could not create flow --> POST /flows");
        throw jsonDecode(res.body)['error'];
      } else {
        return FlowModel.fromJson(res.body);
      }

    } catch (e) {
      try {
        // otherwise make a FlowModel without POSTing it.
        final flowModel = FlowModel(
          id: const Uuid().v6(),
          name: name,
          description: description,
          apparatus: apparatus,
          createdBy: createdBy,
          updatedBy: createdBy,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: 0,
          primaryImageId: primaryImageId,
          primaryImageUrl: Constants.missingImageUrl, // Note: This will update in backend but is required here because it is a required field in FlowModel
        );
        // await flowLocalRepository.insertFlow(flowModel); // TODO shouldnt this insert???
        return flowModel;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<List<FlowModel>> getFlows({
    required String token,
  }) async {
    try {

      final res = await http.get(
          Uri.parse("${Constants.backendUri}/flows"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          }
      );

      if(res.statusCode != 200) {
        print("ERROR: Remote repository fetch error - GET /flows");
        print(res.body);
        throw jsonDecode(res.body)['error'];
      }

      final remoteFlowsList = jsonDecode(res.body);

      List<FlowModel> remoteFlowsListMapped = [];

      for (var element in remoteFlowsList) {
        remoteFlowsListMapped.add(FlowModel.fromMap(element));
      }

      await flowLocalRepository.insertFlows(remoteFlowsListMapped);

      return remoteFlowsListMapped;
    } catch (e) {
      final flows = await flowLocalRepository.getFlows();
      if (flows.isNotEmpty) {
        return flows;
      }
      rethrow; // same as throw (e)
    }
  }

  Future<bool> syncFlows({
    required String token,
    required List<FlowModel> flows,

  }) async {
    try {
      final flowListInMap = [];
      for (final flow in flows) {
        flowListInMap.add(flow.toMap());
      }
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/flows/sync"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(flowListInMap),
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


  Future<FlowModel> updateFlow({
    required FlowModel updatedFlow,
    required String token,
  }) async {
    try {
      final res = await http.put(
        Uri.parse("${Constants.backendUri}/flows/update/${updatedFlow.id}"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(updatedFlow.toJson()), // Convert FlowModel to JSON
      );

      if (res.statusCode != 200) {
        print("ERROR: Could not update flow --> PUT /flows/update/${updatedFlow.id}");
        throw jsonDecode(res.body)['error'];
      } else {
        return FlowModel.fromJson(res.body);
      }
    } catch (e) {
      try {
        // Handle local update
        await flowLocalRepository.updateFlow(updatedFlow);
        return updatedFlow;
      } catch (localUpdateError){
        rethrow;
      }
    }
  }

}