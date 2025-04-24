import 'package:frontend/data/datasources/flows/flow_local_data.dart';
import 'package:frontend/data/datasources/flows/flow_remote_data.dart';
import 'package:frontend/data/datasources/flows/flow_pose_local_data.dart';
import 'package:frontend/data/datasources/flows/flow_pose_remote_data.dart';
import 'package:frontend/data/datasources/poses/pose_local_data.dart'; // To fetch PoseModel

import 'package:frontend/data/models/flow_model.dart';
import 'package:frontend/data/models/flow_pose_model.dart';
import 'package:frontend/data/models/pose_model.dart';

import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';

import '../mappers/flow_mapper.dart';
import '../mappers/pose_mapper.dart';

class FlowRepository {
  final FlowLocalDataSource flowLocalDataSource;
  final FlowPoseLocalDataSource flowPoseLocalDataSource;
  final PoseLocalDataSource poseLocalDataSource;

  final FlowRemoteDataSource flowRemoteDataSource;
  final FlowPoseRemoteDataSource flowPoseRemoteDataSource;

  FlowRepository({
    required this.flowLocalDataSource,
    required this.flowPoseLocalDataSource,
    required this.poseLocalDataSource,
    required this.flowRemoteDataSource,
    required this.flowPoseRemoteDataSource,
  });


  /// Convert FlowPoseModels list to PoseModels list
  Future<List<PoseModel>> flowPoseModelsToPoseModels(
      List<FlowPoseModel> flowPoses
      ) async {
    List<PoseModel> poses = [];
    for (final flowPose in flowPoses) {
      final pose = await poseLocalDataSource.getPoseById(flowPose.poseId);
      if (pose != null) {
        poses.add(pose);
      } else {
        print("Pose with ID ${flowPose.poseId} not found in local db.");
      }
    }
    // TODO might need to move to flow_mapper.dart ?
    return poses;
  }

  /* Flow Model Functions */
  /// Converts a FlowModel to a FlowEntity with its ordered list of PoseEntity.
  Future<FlowEntity> _flowModelToEntity(FlowModel flowModel) async {
    List<FlowPoseModel> flowPoseModels = await flowPoseLocalDataSource.getFlowPosesInFlow(flowModel.id);
    List<PoseModel> poseModels = await flowPoseModelsToPoseModels(flowPoseModels);

    return FlowMapper.modelToEntity(flowModel: flowModel, poseModels: poseModels);
  }



  /// Convert PoseModels list to FlowPoseModels list
  // TODO
  //  List<FlowPoseModel> generateFlowPosesFromPoseModels(
  //   String flowId,
  //   List<PoseModel> poseModels
  // ) {
  //   return List.generate(poseModels.length, (index) {
  //     final pose = poseModels[index];
  //     return FlowPoseModel(
  //       id: '$flowId_${pose.id}', // Or null if using autoincrement
  //       flowId: flowId,
  //       poseId: pose.id,
  //       order: index,
  //     );
  //   });
  // }


  // TODO : FlowModel _flowEntityToModel(FlowEntity entity)

  // TODO : List<FlowPoseModel> flowEntityToFlowPoseModels(FlowEntity entity)

  /* CRUD (Create Read Update Delete) */

  // TODO : Future<void> createFlow(FlowEntity flowEntity)

  // TODO: Future<List<FlowEntity>> getLocalFlows()

  // TODO : Future<void> updateFlow(FlowEntity flowEntity)
  // Future<void> updateFlow(FlowEntity flowEntity) async {
  //   final db = await database;
  //
  //   // Step 1: Convert FlowEntity to FlowModel and update it
  //   final flowModel = FlowMapper.entityToModel(flowEntity);
  //   await db.update(
  //     'flows', // Replace with your actual table name
  //     flowModel.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [flowModel.id],
  //   );
  //
  //   // Step 2: Delete all existing FlowPoseModels for this flow
  //   await db.delete(
  //     'flow_poses', // Replace with your actual table name
  //     where: 'flow_id = ?',
  //     whereArgs: [flowModel.id],
  //   );
  //
  //   // Step 3: Generate new FlowPoseModels with fresh UUIDs
  //   final newFlowPoseModels = FlowMapper.entityToFlowPoseModels(flowEntity);
  //
  //   // Step 4: Insert the new FlowPoseModels
  //   for (final flowPose in newFlowPoseModels) {
  //     await db.insert('flow_poses', flowPose.toMap());
  //   }
  //
  //   print('Flow ${flowEntity.id} updated successfully');
  // }

  /// Update a flow remotely and locally
  Future<void> updateFlow({
    required FlowEntity updatedFlow,
    required String token,
  }) async {
    // Convert to model
    final flowModel = FlowMapper.entityToModelMetaData(updatedFlow);
    final flowPoseModels = FlowMapper.entityToFlowPoseModels(updatedFlow);

    // Update remotely
    await flowRemoteDataSource.updateFlow(
      updatedFlow: flowModel,
      token: token,
    );
    // TODO update flow Poses remotely too!

    // Update locally
    await flowLocalDataSource.updateFlow(flowModel);
    flowPoseLocalDataSource.deleteFlowPoseInFlow(updatedFlow.id);
    flowPoseLocalDataSource.insertFlowPoses(flowPoseModels);
  }



  // TODO : Future<void> deleteFlow(String flowId)


  /* Sync Functions */

  // 7. Future<void> syncRemoteToLocalFlows(List<FlowEntity> remoteFlows)

  // Future<List<FlowEntity>> syncLocalToRemoteFlows()

//
//   /// Creates a new flow.
//   Future<FlowEntity> createFlow({required String name, String? description, required String createdBy, required String token}) async {
//     final flowModel = await flowRemoteDataSource.createFlow(name: name, description: description, createdBy: createdBy, token: token);
//     await flowLocalDataSource.insertFlow(flowModel);
//     return _flowModelToEntity(flowModel);
//   }
//
//   /// Fetches all flows from the local database.
//   Future<List<FlowEntity>> getLocalFlows() async {
//     final flowModels = await flowLocalDataSource.getFlows();
//     List<FlowEntity> flows = [];
//     for (final flowModel in flowModels) {
//       final flowEntity = await _flowModelToEntity(flowModel);
//       flows.add(flowEntity);
//     }
//     return flows;
//   }
//
//   /// Syncs flows from the remote database to the local database.
//   Future<void> syncRemoteFlowsToLocal(String token) async {
//     final flowModels = await flowRemoteDataSource.fetchRemoteFlows(token: token);
//     for (final flowModel in flowModels) {
//       await flowLocalDataSource.insertFlow(flowModel);
//       // TODO: Fetch and sync flow_poses as well
//     }
//   }
//
// // Implement other repository methods like addPose, updatePoseOrder, removePose, syncLocalFlowsToRemote, etc.
// // These will involve interacting with both flow and flow_pose local and remote data sources.
}