import 'dart:developer';

import 'package:frontend/features/students/domain/student_entity.dart';
import 'package:frontend/features/students/domain/student_mapper.dart';

import '../data/student_local_data.dart';
import '../data/student_remote_data.dart';

class StudentRepository {
  final StudentLocalDataSource localDataSource;
  final StudentRemoteDataSource remoteDataSource;

  StudentRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  /// Fetch all students from local DB
  Future<List<StudentEntity>> getAllStudents() async {
    // log('[StudentsRepository] Fetching StudentModels from local database... ');

    final studentModels = await localDataSource.getAllStudents();

    // log('[StudentsRepository] Converting models to entities');
    final studentEntitiesList = StudentMapper.modelsToEntities(studentModels);
    log('[StudentsRepository] Got ${studentModels.length} student entities from local database');
    // log('[StudentsRepository] Conversion complete');

    return studentEntitiesList;
  }
}