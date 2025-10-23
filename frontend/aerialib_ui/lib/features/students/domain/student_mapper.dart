import 'package:frontend/features/students/domain/student_entity.dart';

import '../data/student_model.dart';

class StudentMapper {
  /// Convert a StudentModel to a StudentEntity
  static StudentEntity modelToEntity(StudentModel model) {
    return StudentEntity(
      id: model.id,
      name: model.name,
      isSynced: model.isSynced,
    );
  }

  /// Convert a StudentEntity to a StudentModel
  static StudentModel entityToModel(StudentEntity entity) {
    return StudentModel(
      id: entity.id,
      name: entity.name,
      isSynced: entity.isSynced,
    );
  }

  /// Convert a list of StudentModels to a list of StudentEntities
  static List<StudentEntity> modelsToEntities(List<StudentModel> models) {
    return models.map(modelToEntity).toList();
  }

  /// Convert a list of StudentEntities to a list of StudentModels
  static List<StudentModel> entitiesToModels(List<StudentEntity> entities) {
    return entities.map(entityToModel).toList();
  }
}
