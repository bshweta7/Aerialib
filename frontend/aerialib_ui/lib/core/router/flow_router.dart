import 'package:go_router/go_router.dart';

import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/presentation/pages/flows/add_new_flow_page.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_details_page.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_poses_page.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';
import 'package:frontend/presentation/pages/flows/flow_view_page.dart';


List<GoRoute> flowRoutes = [
  // Flow Library Page
  GoRoute(
    path: '/flows',
    name: 'flow-library',
    builder: (context, state) => const FlowLibraryPage(),
  ),

  // Add New Flow Page
  GoRoute(
    path: '/flows/new',
    name: 'add-new-flow',
    builder: (context, state) {
      final flows = state.extra as List<FlowEntity>; // TODO maybe change this to a list of strings instead of flowEntity
      return AddNewFlowPage(usersExistingFlows: flows);
    },
  ),

  // Flow View Page
  GoRoute(
    // TODO add ?isShared to url - flowName only if its private, and flowId if its public? not sure....
    path: '/flows/view/:flowId',
    name: 'flow-view',
    builder: (context, state) {
      // final flowName = state.pathParameters['flowName']!;
      // final userName = state.pathParameters['userName']!;
      final flow = state.extra as FlowEntity;
      return FlowViewPage(flow: flow);
    },
  ),

  // Edit Flow Details Page
  GoRoute(
    path: '/flows/details/edit/:flowId',
    name: 'flow-edit-details',
    builder: (context, state) {
      final flow = state.extra as FlowEntity;
      return FlowEditDetailsPage(flow: flow);
    },
  ),

  // Edit Flow Poses Page
  GoRoute(
    path: '/flows/poses/edit/:flowId',
    name: 'flow-edit-poses',
    builder: (context, state) {
      final flow = state.extra as FlowEntity;
      return FlowEditPosesPage(flow: flow);
    },
  ),
];