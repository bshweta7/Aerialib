import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/presentation/pages/flows/add_new_flow_page.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_details_page.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_poses_page.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';
import 'package:frontend/presentation/pages/flows/flow_view_page.dart';

import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';

import '../../presentation/cubit/users/auth_cubit.dart';
import 'package:frontend/presentation/cubit/navigation/nav_history_cubit.dart';


List<GoRoute> flowRoutes = [
  /// Flow Library Page
  GoRoute(
    path: '/flows',
    name: 'flow-library',
    builder: (context, state) {
      context.read<NavHistoryCubit>().push(
          state.uri.queryParameters['from']
      );
      return const FlowLibraryPage();
    },
  ),


  /// Add New Flow Page
  GoRoute(
    path: '/flows/new',
    name: 'add-new-flow',
    builder: (context, state) {
      context.read<NavHistoryCubit>().push(
          state.uri.queryParameters['from']
      );
      return const AddNewFlowPage();
    },
  ),


  /// Flow View Page
  GoRoute(
    // TODO add ?isShared to url - flowName only if its private, and flowId if its public? not sure....
    path: '/flows/view/:flowId',
    name: 'flow-view',
    builder: (context, state) {
      final flowId = state.pathParameters['flowId']!;
      return FlowPageWrapper(
        flowId: flowId,
        builder: (flow) => FlowViewPage(flow: flow),
      );
    }
  ),


  /// Edit Flow Details Page
  GoRoute(
    path: '/flows/details/edit/:flowId',
    name: 'flow-edit-details',
    builder: (context, state) {
      final flowId = state.pathParameters['flowId']!;
      return FlowPageWrapper(
        flowId: flowId,
        builder: (flow) => FlowEditDetailsPage(flow: flow),
      );
    }
  ),


  /// Edit Flow Poses Page
  GoRoute(
    path: '/flows/poses/edit/:flowId',
    name: 'flow-edit-poses',
    builder: (context, state) {
      final flowId = state.pathParameters['flowId']!;
      print("[FlowRouter] Builder called...");
      return FlowPageWrapper(
        flowId: flowId,
        builder: (flow) => FlowEditPosesPage(flow: flow),
        expectedState: EditFlowState,
      );
    },
  ),
];



class FlowPageWrapper extends StatelessWidget {
  final String flowId;
  final Widget Function(FlowEntity flow) builder;
  final expectedState;

  const FlowPageWrapper({
    super.key,
    required this.flowId,
    required this.builder,
    this.expectedState = GetFlowsSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FlowsCubit>().state;

    print("[FlowRouter] State is $state");
    if (state is! GetFlowsSuccess || state is! EditFlowState) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final flow = state.flows.firstWhere(
          (f) => f.id == flowId,
      orElse: () => throw Exception('Flow not found'),
    );

    return builder(flow);
  }
}
