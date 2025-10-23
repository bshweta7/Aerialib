import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:frontend/features/students/data/student_model.dart';
import 'package:frontend/core/services/local_database_service.dart';

class StudentLocalDataSource {
  String tableName = 'students';

  Future<Database> get database async => DatabaseService.database;

  Future<List<StudentModel>> getAllStudents() async {
    final db = await database;
    final result = await db.query(tableName);

    if (result.isNotEmpty) {
      List<StudentModel> students = [];
      for (final elem in result) {
        students.add(StudentModel.fromMap(elem));
      }
      return students;
    } else {
      return [];
    }
  }
}