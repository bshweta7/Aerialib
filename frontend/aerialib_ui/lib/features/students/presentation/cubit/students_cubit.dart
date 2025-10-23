import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/student_entity.dart';
import '../../domain/student_repository.dart';


part 'students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final StudentRepository _studentRepository;
  bool _isSyncing = false;

  StudentsCubit(this._studentRepository) : super(const StudentInitial());

  List<StudentEntity> get students {
    final currentState = state;
    if (currentState is GetStudentsSuccess) {
      return currentState.students;
    }
    return [];
  }

  /// Fetch all students (from local storage or remote if needed)
  Future<void> getAllStudents({required String token}) async {
    try {
      log('[StudentsCubit] Fetching students...');
      emit(const StudentLoading());

      List<StudentEntity> allStudents = await _studentRepository.getAllStudents();  // Fetch local students
      log('[StudentsCubit] Number of Students Retrieved: ${allStudents.length}');
      emit(GetStudentsSuccess(allStudents));

    } catch (e) {
      log('[StudentsCubit] GetAllStudents failed: $e');
      emit(StudentError(e.toString()));
    }
  }

  Future<void> refresh({required String token}) async {
    try {
      emit(const StudentLoading());
      final allStudents = await _studentRepository.getAllStudents();
      emit(GetStudentsSuccess(allStudents));
    } catch (e) {
      emit(StudentError('Refresh error: ${e.toString()}'));
    }
  }

  Future<void> refreshLocalOnly() async {
    try {
      final allStudents = await _studentRepository.getAllStudents();
      emit(GetStudentsSuccess(allStudents));
    } catch (e) {
      emit(StudentError('Local refresh error: ${e.toString()}'));
    }
  }

}


