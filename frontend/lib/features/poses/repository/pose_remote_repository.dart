import 'dart:async';
import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/poses/repository/pose_local_repository.dart';
import 'package:frontend/models/pose_model.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/utils.dart';

class PoseRemoteRepository {
  final poseLocalRepository = PoseLocalRepository();

  Future<PoseModel> createPose({
    required String title,
    required String description,
    required String hexColor,
    required String token,
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
            'hexColor': hexColor,
            'dueAt': dueAt.toIso8601String(),
          })
      );

      if(res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      return PoseModel.fromJson(res.body);
    } catch (e) {
      try {
        final poseModel = PoseModel(
          id: '',
          uid: '',
          title: title,
          description: description,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          dueAt: dueAt,
          color: hexToRgb(hexColor),
          isSynced: 0,
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
        print("REPO FETCH ERROR :(");
        print(res.body);
        throw jsonDecode(res.body)['error'];
      }

      final listOfPoses = jsonDecode(res.body);
      List<PoseModel> posesList = [];

      for (var element in listOfPoses) {
        posesList.add(PoseModel.fromMap(element));
      }

      return posesList;
    } catch (e) {
      final poses = await poseLocalRepository.getPoses();
      if (poses.isNotEmpty) {
        return poses;
      }
      rethrow; // same as throw (e)
    }
  }

}