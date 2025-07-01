import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/transitions/presentation/pages/add_new_transition_page.dart';
import 'package:frontend/features/transitions/presentation/pages/transition_library.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/shared/features/navigation/cubit/nav_history_cubit.dart';

import '../../features/transitions/presentation/cubit/transition_cubit.dart';
import '../../features/transitions/presentation/pages/transition_view_page.dart';



List<GoRoute> transitionRoutes = [
  /// Transition Library Page
  GoRoute(
    path: '/transitions',
    name: 'transition-library',
    builder: (context, state) {
      context.read<NavHistoryCubit>().push(
          state.uri.queryParameters['from']
      );
      return const TransitionLibraryPage();
    },
  ),

  /// Add New Transition Page
  GoRoute(
    path: '/transitions/new',
    name: 'add-new-transition',
    builder: (context, state) {
      context.read<NavHistoryCubit>().push(
          state.uri.queryParameters['from']
      );
      return const AddNewTransitionPage();
    },
  ),

  /// Transition View
  GoRoute(
    path: '/transition/:transitionId',
    name: 'transition-view',
    builder: (context, state) {

      // Update Navigation History
      context.read<NavHistoryCubit>().push(
          state.uri.queryParameters['from']
      );

      // Get transition entity from transition ID
      final transitionId = state.pathParameters['transitionId']!;
      final transitionsState = context.read<TransitionCubit>().state;

      if (transitionsState is GetTransitionsSuccess) {
        final transition = transitionsState.transitions.firstWhere(
              (p) => p.id == transitionId,
          orElse: () => throw Exception('Transition not found'),
        );

        return TransitionViewPage(transition: transition);
      }

      // Fallback or loading
      log('[TransitionRouter] $transitionsState');
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    },
  ),
];
