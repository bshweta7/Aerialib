import 'package:go_router/go_router.dart';

import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/presentation/pages/poses/add_new_pose_page.dart';
import 'package:frontend/presentation/pages/poses/pose_edit_page.dart';
import 'package:frontend/presentation/pages/poses/pose_library_page.dart';
import 'package:frontend/presentation/pages/poses/pose_view_page.dart';


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

  // View Pose Page
  GoRoute(
    path: '/poses/view/:poseId',
    name: 'pose-view',
    builder: (context, state) {
      final pose = state.extra as PoseEntity;
      return PoseViewPage(pose:pose);
    },
  ),

  // Edit Pose Page
  GoRoute(
    path: '/poses/edit/:poseId',
    name: 'pose-edit',
    builder: (context, state) {
      final pose = state.extra as PoseEntity;
      return PoseEditDetailsPage(pose:pose);
    },
  ),
];