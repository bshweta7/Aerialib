import 'package:frontend/data/models/pose_model.dart';
import 'package:frontend/domain/entities/pose_entity.dart';

import '../../core/constants/constants.dart';
import '../../data/models/media_model.dart';

class PoseMapper {
  /// Convert a PoseModel to a PoseEntity
  static PoseEntity modelToEntity(
      PoseModel model,
      String mediaPath
      ) {
    return PoseEntity(
      id: model.id,
      name: model.name,
      primaryImageId: model.primaryImageId,
      primaryMediaPath: mediaPath ?? Constants.missingImagePath,
      apparatus: model.apparatus,
      level: model.level,
      description: model.description,
      teachingCues: model.teachingCues,
      safetyCues: model.safetyCues,
      progressions: model.progressions,
      createdBy: model.createdBy,
      updatedBy: model.updatedBy,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      isSynced: model.isSynced,
    );
  }

  /// Convert a PoseEntity to a PoseModel
  static PoseModel entityToModel(PoseEntity entity) {
    return PoseModel(
      id: entity.id,
      name: entity.name,
      primaryImageId: entity.primaryImageId,
      apparatus: entity.apparatus,
      level: entity.level,
      description: entity.description,
      teachingCues: entity.teachingCues,
      safetyCues: entity.safetyCues,
      progressions: entity.progressions,
      createdBy: entity.createdBy,
      updatedBy: entity.updatedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  /// Convert a list of PoseModels to a list of PoseEntities
  static List<PoseEntity> modelsToEntities(
      List<PoseModel> models,
      List<MediaModel> mediaList,
      ) {
    // Create a lookup map for faster access
    final mediaPathMap = {
      for (var media in mediaList) media.id: media.path,
    };

    return models.map((model) {
      final mediaPath = mediaPathMap[model.primaryImageId] ?? Constants.missingImagePath;
      return modelToEntity(model, mediaPath);
    }).toList();
  }


  /// Convert a list of PoseEntities to a list of PoseModels
  static List<PoseModel> entitiesToModels(List<PoseEntity> entities) {
    return entities.map(entityToModel).toList();
  }
}
