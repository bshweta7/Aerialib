import 'dart:convert';

import 'package:frontend/core/services/http_service.dart';
import 'package:frontend/features/students/data/student_model.dart';

class StudentRemoteDataSource {
  final HttpService httpService;

  StudentRemoteDataSource({required this.httpService});

  /// Get all students from remote database
  Future<List<StudentModel>> getRemoteStudents({
    required String token,
  }) async {
    final response = await httpService.get(
      path: "/students",
      token: token,
    );

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((e) => StudentModel.fromMap(e).copyWith(isSynced: 1)).toList();
  }
}
