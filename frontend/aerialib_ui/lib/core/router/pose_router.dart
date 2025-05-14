import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/cubit/navigation/nav_history_cubit.dart';

import 'package:frontend/presentation/pages/poses/add_new_pose_page.dart';
import 'package:frontend/presentation/pages/poses/pose_edit_page.dart';
import 'package:frontend/presentation/pages/poses/pose_library_page.dart';
import 'package:frontend/presentation/pages/poses/pose_view_page.dart';



List<GoRoute> poseRoutes = [
  /// Pose Library Page
  GoRoute(
    path: '/poses',
    name: 'pose-library',
    builder: (context, state) {
      context.read<NavHistoryCubit>().push(
          state.uri.queryParameters['from']
      );
      return const PoseLibraryPage();
    },
  ),


  /// Add New Pose Page
  GoRoute(
    path: '/poses/new',
    name: 'add-new-pose',
    builder: (context, state) => const AddNewPosePage(),
    // TODO update this with smart button and nav History (see pose library)
  ),


  /// View Pose Page
  GoRoute(
    path: '/poses/view/:poseId',
    name: 'pose-view',
    builder: (context, state) {
      // Update Navigation History
      context.read<NavHistoryCubit>().push(
          state.uri.queryParameters['from']
      );

      // Get pose entity from pose ID
      final poseId = state.pathParameters['poseId']!;
      final posesState = context.read<PosesCubit>().state;

      if (posesState is GetPosesSuccess) {
        final pose = posesState.poses.firstWhere(
          (p) => p.id == poseId,
          orElse: () => throw Exception('Flow not found'),
        );

        return PoseViewPage(
          pose: pose,
        );
      }

      // Fallback or loading
      print(posesState);
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    },
  ),


  /// Edit Pose Page
  GoRoute(
    path: '/poses/edit/:poseId',
    name: 'pose-edit',
    builder: (context, state) {
      final pose = state.extra as PoseEntity;
      return PoseEditDetailsPage(pose:pose);
    },
    // TODO update this with smart button and nav History (see pose library)
  ),
];