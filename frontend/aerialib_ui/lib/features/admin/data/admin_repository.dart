import 'dart:convert';
import 'dart:developer';

import 'package:frontend/features/flow/data/models/flow_model.dart';
import 'package:frontend/core/services/http_service.dart';

import '../../user/data/models/user_model.dart';
import 'admin_flow_model.dart';

class AdminRepository {
  final HttpService httpService;

  AdminRepository({required this.httpService});

  Future<List<UserModel>> getAllUsers({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/admin/users",
      token: token,
    );

    log(response.body);
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList
        .map((e) => UserModel.fromMap(e))
        .toList();
  }

  Future<List<UserModel>> getStudents({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/admin/studentRoster",
      token: token,
    );

    log(response.body);
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList
        .map((e) => UserModel.fromMap(e))
        .toList();
  }

  Future<List<AdminFlowModel>> getAllFlows({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/admin/flows",
      token: token,
    );

    log(response.body);
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList
        .map((e) => AdminFlowModel.fromMap(e))
        .toList();
  }
}
