import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/data/datasources/flows/flow_remote_data.dart';
import 'package:frontend/data/datasources/flows/flow_local_data.dart';

import 'package:frontend/to_sort/models/flow_model.dart';

part 'flow_state.dart';

class FlowsCubit extends Cubit<FlowsState> {
  FlowsCubit() : super(FlowInitial());
  final flowRemoteRepository = FlowRemoteRepository();
  final flowLocalRepository = FlowLocalDataSource();

  // FLOWS ONLY
  Future<void> createNewFlow({
    required String name,
    required String description,
    required String apparatus,
    required String primaryImageId,
    required String token,
    required String createdBy,
  }) async {
    try {
      emit(FlowLoading());
      final flowModel = await flowRemoteRepository.createFlow(
        name: name,
        description: description,
        apparatus: apparatus,
        primaryImageId: primaryImageId,
        token: token,
        createdBy: createdBy,
      );
      await flowLocalRepository.insertFlow(flowModel);

      emit(AddNewFlowSuccess(flowModel));
    } catch (e) {
      print(e.toString());
      emit(FlowError(e.toString()));
    }
  }

  Future<void> getAllFlows({required String token,
  }) async {
    try {
      emit(FlowLoading());
      final flows = await flowRemoteRepository.getFlows(token: token);
      emit(GetFlowsSuccess(flows));
    } catch (e) {
      print(e.toString());
      emit(FlowError(e.toString()));
    }
  }

  Future<void> syncFlows(String token) async {
    // get all unsynced flows from our sqlite db
    final unsyncedFlows = await flowLocalRepository.getUnsyncedFlows();

    if (unsyncedFlows.isEmpty) {
      return;
    }

    print("Unsynced flows:");
    print(unsyncedFlows);

    // talk to our postgresql db to add the new flow
    final isSynced = await flowRemoteRepository.syncFlows(
        token: token,
        flows: unsyncedFlows
    );
    // change the flows that were added to the db from 0 to 1
    if (isSynced) {
      print("Flows have been synced");
      for (final flow in unsyncedFlows) {
        flowLocalRepository.setSyncedStatus(flow.id, 1);
      }
    }
  }

  Future<void> updateFlowInfo({
    required FlowModel updatedFlow,
    required String token,
  }) async {
    try {
      emit(FlowLoading());
      final flowModel = await flowRemoteRepository.updateFlow(
        updatedFlow: updatedFlow,
        token: token,
      );
      await flowLocalRepository.updateFlow(
          flowModel); // Update local repository

      emit(UpdateFlowSuccess(flowModel)); // Emit success state
    } catch (e) {
      print(e.toString());
      emit(FlowError(e.toString()));
    }
  }
}