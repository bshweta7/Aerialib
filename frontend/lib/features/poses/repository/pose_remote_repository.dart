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
    required String title,
    required String description,
    required String color,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
      final res = await http.post(
          Uri.parse("${Constants.backendUri}/poses"),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'title': title,
            'description': description,
            'color': color,
            'dueAt': dueAt.toIso8601String(),
          })
      );

      if(res.statusCode != 201) {
        print("ERROR: Could not create pose - POST /poses");
        throw jsonDecode(res.body)['error'];
      }

      return PoseModel.fromJson(res.body);
    } catch (e) {
      try {
        final poseModel = PoseModel(
          id: const Uuid().v6(),
          uid: uid,
          title: title,
          description: description,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          dueAt: dueAt,
          color: hexToRgb(color),
          isSynced: 0,
          imageURL: "",
          thumbnailURL: ""
        );
        // await poseLocalRepository.insertPose(poseModel);
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