import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/shared/features/navigation/cubit/nav_history_cubit.dart';

import '../../features/transitions/presentation/cubit/transition_cubit.dart';
import '../../features/transitions/presentation/pages/transition_view_page.dart';



List<GoRoute> transitionRoutes = [
  /// Transition View
  GoRoute(
    path: '/transition/:transitionId',
    name: 'transition-view',
    builder: (context, state) {

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
