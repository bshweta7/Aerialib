import 'dart:async';
import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/repositories/transition_local_repository.dart';
import 'package:frontend/models/transition_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class TransitionRemoteRepository {
  final transitionLocalRepository = TransitionLocalRepository();

  Future<TransitionModel> createTransition({
    required String fromPoseId,
    required String toPoseId,
    required String name,
    required String description,
    required String cues,
    required int difficulty,
    required double duration,
    required String primaryVideoId,
    required String token,

  }) async {

    try {
      // First try POST into backend
      final res = await http.post(
          Uri.parse("${Constants.backendUri}/transition"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'fromPoseId': fromPoseId,
            'toPoseId': toPoseId,
            'name': name,
            'description': description,
            'cues': cues,
            'difficulty': difficulty,
            'duration': duration,
            'primaryVideoId': primaryVideoId,
          })
      );

      if(res.statusCode != 201) {
        print("ERROR: Could not create transition --> POST /transition");
        throw jsonDecode(res.body)['error'];
      } else {
        return TransitionModel.fromJson(res.body);
      }

    } catch (e) {
      try {
        // otherwise make a TransitionModel without POSTing it.
        final transitionModel = TransitionModel(
          id: const Uuid().v6(),
          fromPoseId: fromPoseId,
          toPoseId: toPoseId,
          name: name,
          description: description,
          cues: cues,
          difficulty: difficulty,
          duration: duration,
          primaryVideoId: primaryVideoId,
          isSynced: 0,

        );
        // await transitionLocalRepository.insertTransition(transitionModel); // TODO shouldnt this insert???
        return transitionModel;
      } catch (e) {
        rethrow;
      }
    }
  }


  Future<List<TransitionModel>> getTransitionList({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse("${Constants.backendUri}/transition"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          }
      );

      if(res.statusCode != 200) {
        print("ERROR: Remote repository fetch error - GET /transition");
        // print(res.body);
        throw jsonDecode(res.body)['error'];
      }

      final remoteTransitionList = jsonDecode(res.body);
      List<TransitionModel> remoteTransitionListMapped = [];

      for (var element in remoteTransitionList) {
        remoteTransitionListMapped.add(TransitionModel.fromMap(element));
      }

      await transitionLocalRepository.insertTransitionList(remoteTransitionListMapped);

      return remoteTransitionListMapped;
    } catch (e) {
      final transitionList = await transitionLocalRepository.getTransitionList();
      if (transitionList.isNotEmpty) {
        return transitionList;
      }
      rethrow; // same as throw (e)
    }
  }

  Future<bool> syncTransition({
    required String token,
    required List<TransitionModel> transitionList,

  }) async {
    try {
      final transitionListInMap = [];
      for (final transition in transitionList) {
        transitionListInMap.add(transition.toMap());
      }
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/transition/sync"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(transitionListInMap),
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

}