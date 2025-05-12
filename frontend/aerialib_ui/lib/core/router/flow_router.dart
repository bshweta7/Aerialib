import 'package:frontend/presentation/pages/flows/add_new_flow_page.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/presentation/pages/flows/flow_view_page.dart';


List<GoRoute> flowRoutes = [
  GoRoute(
    path: '/flows',
    name: 'flow-library',
    builder: (context, state) => const FlowLibraryPage(),
  ),
  GoRoute(
    path: '/flows/new',
    name: 'add-new-flow',
    builder: (context, state) => const AddNewFlowPage(),
  ),

  GoRoute(
    // TODO add ?isShared to url - flowName only if its private, and flowId if its public? not sure....
    path: '/flows/view/:flowId',
    name: 'flow-view',
    builder: (context, state) {
      final flowId = state.pathParameters['flowId']!;
      // final flowName = state.pathParameters['flowName']!;
      // final userName = state.pathParameters['userName']!;
      final flow = state.extra as FlowEntity;
      return FlowViewPage(flow: flow);
    },
  ),

  // GoRoute(
  //   path: '/',
  //   name: 'landing',
  //   builder: (context, state) => const LandingPage(),
  // ),
  // GoRoute(
  //   path: '/',
  //   name: 'landing',
  //   builder: (context, state) => const LandingPage(),
  // ),
  // GoRoute(
  //   path: '/',
  //   name: 'landing',
  //   builder: (context, state) => const LandingPage(),
  // ),
];