import 'package:frontend/features/tags/data/tag_model.dart';
import 'package:frontend/features/tags/domain/tag_entity.dart';

class TagMapper {
  /// Convert TagModel to TagEntity
  static TagEntity modelToEntity(TagModel model) {
    return TagEntity(
      id: model.id,
      name: model.name,
      userId: model.userId,
      color: model.color,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isSynced: model.isSynced,
    );
  }

  /// Convert TagEntity to TagModel
  static TagModel entityToModel(TagEntity entity) {
    return TagModel(
      id: entity.id,
      name: entity.name,
      userId: entity.userId,
      color: entity.color,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }
}
