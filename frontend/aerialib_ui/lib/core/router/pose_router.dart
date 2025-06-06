import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:frontend/shared/features/navigation/cubit/nav_history_cubit.dart';

import 'package:frontend/features/pose/presentation/pages/add_new_pose_page.dart';
import 'package:frontend/features/pose/presentation/pages/pose_edit_page.dart';
import 'package:frontend/features/pose/presentation/pages/pose_library_page.dart';
import 'package:frontend/features/pose/presentation/pages/pose_view_page.dart';



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
          orElse: () => throw Exception('Pose not found'),
        );

        return PoseViewPage(
          pose: pose,
        );
      }

      // Fallback or loading
      log('[PoseRouter] $posesState');
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

      // Get pose entity from pose ID
      final poseId = state.pathParameters['poseId']!;
      final posesState = context.read<PosesCubit>().state;

      if (posesState is GetPosesSuccess) {
        final pose = posesState.poses.firstWhere(
              (p) => p.id == poseId,
          orElse: () => throw Exception('Pose not found'),
        );

        return PoseEditDetailsPage(pose: pose);
      }

      // Fallback or loading
      log('[PoseRouter] $posesState');
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    },
  ),
];