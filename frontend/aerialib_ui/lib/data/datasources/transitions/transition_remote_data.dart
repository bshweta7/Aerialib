import 'dart:convert';

import 'package:frontend/data/models/transition_model.dart';
import 'package:frontend/data/services/http_service.dart';
import 'package:uuid/uuid.dart';

class TransitionRemoteDataSource {
  final HttpService httpService;

  TransitionRemoteDataSource({required this.httpService});

  /// Create and return TransitionModel
  Future<TransitionModel> createTransition({
    required String fromPoseId,
    required String toPoseId,
    required double level,
    String? name,
    String? description,
    String? teachingCues,
    String? safetyCues,
    String? progressions,
    String? transitionType,
    String? startingGrip,
    String? endingGrip,
    required String createdBy,
    required String token,
  }) async {
    final body = {
      'from_pose_id': fromPoseId,
      'to_pose_id': toPoseId,
      'level': level,
      'created_by': createdBy,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (teachingCues != null) 'teaching_cues': teachingCues,
      if (safetyCues != null) 'safety_cues': safetyCues,
      if (progressions != null) 'progressions': progressions,
      if (transitionType != null) 'transition_type': transitionType,
      if (startingGrip != null) 'starting_grip': startingGrip,
      if (endingGrip != null) 'ending_grip': endingGrip,
    };

    try {
      final response = await httpService.post(
        path: "/transitions",
        token: token,
        body: body,
      );

      return TransitionModel.fromJson(response.body);
    } catch (e) {
      final now = DateTime.now();
      return TransitionModel(
        id: const Uuid().v6(),
        fromPoseId: fromPoseId,
        toPoseId: toPoseId,
        level: level,
        name: name,
        description: description,
        teachingCues: teachingCues,
        safetyCues: safetyCues,
        progressions: progressions,
        transitionType: transitionType,
        startingGrip: startingGrip,
        endingGrip: endingGrip,
        createdBy: createdBy,
        updatedBy: createdBy,
        createdAt: now,
        updatedAt: now,
        isSynced: 0,
      );
    }
  }

  Future<List<TransitionModel>> fetchRemoteTransitions({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/transitions",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => TransitionModel.fromMap(e)).toList();
  }

  Future<bool> syncTransitions({
    required String token,
    required List<TransitionModel> transitions,
  }) async {
    final transitionListInMap =
    transitions.map((t) => t.toMap()).toList();

    final response = await httpService.post(
      path: "/transitions/sync",
      token: token,
      body: transitionListInMap,
    );

    return response.statusCode == 201;
  }

  Future<TransitionModel> updateTransition({
    required TransitionModel updatedTransition,
    required String token,
  }) async {
    final response = await httpService.put(
      path: "/transitions/update/${updatedTransition.id}",
      token: token,
      body: updatedTransition.toJson(),
    );

    return TransitionModel.fromJson(response.body);
  }
}
