import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/shared/features/navigation/cubit/nav_history_cubit.dart';

import 'package:frontend/features/flow/presentation/pages/add_new_flow_page.dart';
import 'package:frontend/features/flow/presentation/pages/flow_edit_details_page.dart';
import 'package:frontend/features/flow/presentation/pages/flow_edit_poses_page.dart';
import 'package:frontend/features/flow/presentation/pages/flow_library_page.dart';
import 'package:frontend/features/flow/presentation/pages/flow_view_page.dart';


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


  /// View Flow Page
  GoRoute(
    path: '/flows/view/:flowId',
    name: 'flow-view',
    builder: (context, state) {
      // Update Navigation History
      context.read<NavHistoryCubit>().push(
        state.uri.queryParameters['from']
      );

      final flowId = state.pathParameters['flowId']!;
      final flowsState = context.read<FlowsCubit>().state;

      if (flowsState is GetFlowsSuccess) {
        final flow = flowsState.flows.firstWhere(
          (f) => f.id == flowId,
          orElse: () => throw Exception('Flow not found'),
        );

        return FlowViewPage(
          flow: flow,
        );
      }

      // Fallback or loading
      log("[FlowRouter] Error loading, state is $flowsState");
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    },
  ),
  // TODO add ?isShared to url - flowName only if its private, and flowId if its public? not sure....


  /// Edit Flow Details Page
  GoRoute(
    path: '/flows/details/edit/:flowId',
    name: 'flow-edit-details',
    builder: (context, state) {
      // Note: not updating to keep base as "flow-library" so
      // flow view isnt base after redirecting back to flow view

      // Update Navigation History
      // context.read<NavHistoryCubit>().push(
      //     state.uri.queryParameters['from']
      // );

      final flowId = state.pathParameters['flowId']!;
      final flowsState = context.read<FlowsCubit>().state;

      if (flowsState is GetFlowsSuccess) {
        final flow = flowsState.flows.firstWhere(
              (f) => f.id == flowId,
          orElse: () => throw Exception('Flow not found'),
        );

        return FlowEditDetailsPage(
          flow: flow,
        );
      }

      // Fallback or loading
      log("[FlowRouter] Error loading, state is $flowsState");
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  ),


  /// Edit Flow Poses Page
  GoRoute(
    path: '/flows/poses/edit/:flowId',
    name: 'flow-edit-poses',
    builder: (context, state) {

      final flowId = state.pathParameters['flowId']!;
      final flowsState = context.read<FlowsCubit>().state;

      if (flowsState is EditFlowState) {
        final flow = flowsState.flow;
        return FlowEditPosesPage(
          flow: flow,
        );
      }

      // TODO this is just for flow-view -> edit-poses. update flow view to emit edit state
      if (flowsState is GetFlowsSuccess) {
        final flow = flowsState.flows.firstWhere(
              (f) => f.id == flowId,
          orElse: () => throw Exception('Flow not found'),
        );

        return FlowEditPosesPage(
          flow: flow,
        );
      }

      // Fallback or loading
      log("[FlowRouter] Error loading, state is $flowsState");
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  ),
];


//
// class FlowPageWrapper extends StatelessWidget {
//   final String flowId;
//   final Widget Function(FlowEntity flow) builder;
//   final expectedState;
//
//   const FlowPageWrapper({
//     super.key,
//     required this.flowId,
//     required this.builder,
//     this.expectedState = GetFlowsSuccess,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<FlowsCubit>().state;
//
//     log("[FlowRouter] State is $state");
//     if (state is! GetFlowsSuccess || state is! EditFlowState) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     final flow = state.flows.firstWhere(
//           (f) => f.id == flowId,
//       orElse: () => throw Exception('Flow not found'),
//     );
//
//     return builder(flow);
//   }
// }
