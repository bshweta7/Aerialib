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


  /// Create a new flow with metadata only (no poses)
  Future<FlowModel> createFlow({
    required String name,
    required String description,
    required String apparatus,
    required String createdBy,
    required String token,
  }) async {
    try {
      final flowModel = await flowRemoteDataSource.createFlow(
        name: name,
        description: description,
        apparatus: apparatus,
        createdBy: createdBy,
        token: token,
      );
      await flowLocalDataSource.insertFlow(flowModel);
      return flowModel;
    } catch (e) {
      // TODO Handle other potential errors (e.g., local database issues)
      rethrow;
    }
  }

  Future<FlowPoseModel> createFlowPose({
    required String flowId,
    required String poseId,
    required int order,
    required String token,
  }) async {
    try {
      final flowPoseModel = await flowPoseRemoteDataSource.createFlowPose(
        flowId: flowId,
        poseId: poseId,
        order: order,
        transitionId: "", // TODO remove
        token: token,
      );
      await flowPoseLocalDataSource.insertFlowPose(flowPoseModel);
      return flowPoseModel;
    } catch (e) {
      // TODO Handle other potential errors (e.g., local database issues)
      rethrow;
    }
  }


  /// Fetch all poses from local DB
  Future<List<FlowEntity>> getLocalFlows() async {
    print("Fetching Flow and FlowPoses from Local Database");

    final flowModels = await flowLocalDataSource.getFlows();
    final flowPoseModels = await flowPoseLocalDataSource.getFlowPoses();

    print("Converting Flow/FlowPoses Models to Flow Entities");

    // Group FlowPoseModels by flowId
    final Map<String, List<FlowPoseModel>> flowPoseMap = {};
    for (final pose in flowPoseModels) {
      flowPoseMap.putIfAbsent(pose.flowId, () => []).add(pose);
    }

    final List<FlowEntity> flowEntities = [];

    for (final flowModel in flowModels) {
      final flowId = flowModel.id;
      final posesInFlow = flowPoseMap[flowId] ?? [];

      // Sort by order to preserve sequence
      posesInFlow.sort((a, b) => a.order.compareTo(b.order));

      // Get PoseModels for the flow
      final poseModels = await FlowMapper.flowPoseModelsToPoseModels(
        posesInFlow,
        poseLocalDataSource.getPoseById,
      );

      // Convert to FlowEntity
      final flowEntity = FlowMapper.modelToEntity(
        flowModel: flowModel,
        poseModels: poseModels,
      );

      flowEntities.add(flowEntity);
    }

    return flowEntities;
  }


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
    await flowPoseLocalDataSource.deleteFlowPoseInFlow(updatedFlow.id);
    await flowPoseLocalDataSource.insertFlowPoses(flowPoseModels);
  }

  /// Delete a flow remotely and locally
  Future<void> deleteFlow({
    required String flowId,
    required String token,
  }) async {
    // TODO delete flow AND flow Poses remotely too!

    await flowLocalDataSource.deleteFlow(flowId);
    await flowPoseLocalDataSource.deleteFlowPoseInFlow(flowId);
  }

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