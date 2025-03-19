import 'dart:async';
import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/poses/repository/pose_local_repository.dart';
import 'package:frontend/models/pose_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:frontend/core/constants/utils.dart';

class PoseRemoteRepository {
  final poseLocalRepository = PoseLocalRepository();

  Future<PoseModel> createPose({
    required String name,
    required String description,
    required String cues,
    required String apparatus,
    required int level,
    required String primaryImageId,
    required String token,
    required String createdBy,
  }) async {

    try {
      // First try POST into backend
      final res = await http.post(
          Uri.parse("${Constants.backendUri}/poses"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'name': name,
            // 'description': description,
            // 'cues': cues,
            'apparatus': apparatus,
            'level': level,
            'createdBy': createdBy,
            'primaryImageId': primaryImageId,
            // TODO why doesnt this include everything? POST thunderclient didnt work when i added a nullable one like description - gave error.
          })
      );

      if(res.statusCode != 201) {
        print("ERROR: Could not create pose --> POST /poses");
        throw jsonDecode(res.body)['error'];
      } else {
        return PoseModel.fromJson(res.body);
      }

    } catch (e) {
      try {
        // otherwise make a PoseModel without POSTing it.
        final poseModel = PoseModel(
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
        );
        // await poseLocalRepository.insertPose(poseModel); // TODO shouldnt this insert???
        return poseModel;
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<List<PoseModel>> getPoses({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse("${Constants.backendUri}/poses"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          }
      );

      if(res.statusCode != 200) {
        print("ERROR: Remote repository fetch error - GET /poses");
        print(res.body);
        throw jsonDecode(res.body)['error'];
      }

      final remotePosesList = jsonDecode(res.body);
      List<PoseModel> remotePosesListMapped = [];

      for (var element in remotePosesList) {
        remotePosesListMapped.add(PoseModel.fromMap(element));
      }

      await poseLocalRepository.insertPoses(remotePosesListMapped);

      return remotePosesListMapped;
    } catch (e) {
      final poses = await poseLocalRepository.getPoses();
      if (poses.isNotEmpty) {
        return poses;
      }
      rethrow; // same as throw (e)
    }
  }

  Future<bool> syncPoses({
    required String token,
    required List<PoseModel> poses,

  }) async {
    try {
      final poseListInMap = [];
      for (final pose in poses) {
        poseListInMap.add(pose.toMap());
      }
      print("TEST");
      final res = await http.post(
        Uri.parse("${Constants.backendUri}/poses/sync"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(poseListInMap),
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