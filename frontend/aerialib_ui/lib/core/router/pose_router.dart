import 'package:frontend/presentation/pages/poses/add_new_pose_page.dart';
import 'package:frontend/presentation/pages/poses/pose_library_page.dart';
import 'package:go_router/go_router.dart';



List<GoRoute> poseRoutes = [
  // Pose Library Page
  GoRoute(
    path: '/poses',
    name: 'pose-library',
    builder: (context, state) => const PoseLibraryPage(),
  ),

  // Add New Pose Page
  GoRoute(
    path: '/poses/new',
    name: 'add-new-pose',
    builder: (context, state) => const AddNewPosePage(),
  ),
  //
  // // Flow View Page
  // GoRoute(
  //   // TODO add ?isShared to url - flowName only if its private, and flowId if its public? not sure....
  //   path: '/flows/view/:flowId',
  //   name: 'flow-view',
  //   builder: (context, state) {
  //     // final flowName = state.pathParameters['flowName']!;
  //     // final userName = state.pathParameters['userName']!;
  //     final flow = state.extra as FlowEntity;
  //     return FlowViewPage(flow: flow);
  //   },
  // ),
  //
  // // Edit Flow Details Page
  // GoRoute(
  //   path: '/flows/details/edit/:flowId',
  //   name: 'flow-edit-details',
  //   builder: (context, state) {
  //     final flow = state.extra as FlowEntity;
  //     return FlowEditDetailsPage(flow: flow);
  //   },
  // ),
  //
  // // Edit Flow Poses Page
  // GoRoute(
  //   path: '/flows/poses/edit/:flowId',
  //   name: 'flow-edit-poses',
  //   builder: (context, state) {
  //     final flow = state.extra as FlowEntity;
  //     return FlowEditPosesPage(flow: flow);
  //   },
  // ),
];