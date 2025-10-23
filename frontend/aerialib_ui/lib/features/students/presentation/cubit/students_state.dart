part of 'students_cubit.dart';

abstract class StudentsState extends Equatable {
  const StudentsState();

  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentsState {
  const StudentInitial();
}

class StudentLoading extends StudentsState {
  const StudentLoading();
}

class GetStudentsSuccess extends StudentsState {
  final List<StudentEntity> students;
  const GetStudentsSuccess(this.students);

  @override
  List<Object?> get props => [students];
}

class AddNewStudentSuccess extends StudentsState {
  final StudentEntity student;
  const AddNewStudentSuccess(this.student);

  @override
  List<Object?> get props => [student];
}

class UpdateStudentSuccess extends StudentsState {
  final StudentEntity updatedStudent;
  const UpdateStudentSuccess(this.updatedStudent);

  @override
  List<Object?> get props => [updatedStudent];
}

class StudentError extends StudentsState {
  final String message;
  const StudentError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteStudentSuccess extends StudentsState {
  final String deletedStudentId;
  const DeleteStudentSuccess(this.deletedStudentId);

  @override
  List<Object?> get props => [deletedStudentId];
}
