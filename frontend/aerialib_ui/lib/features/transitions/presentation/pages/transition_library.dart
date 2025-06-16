import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/transitions/domain/transition_entity.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/shared/helpers/conversions.dart';

import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';

import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';

import 'package:frontend/features/pose/presentation/widgets/pose_filter_sheet.dart';
import 'package:frontend/shared/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/shared/widgets/media_display/multi_card_view/media_list.dart';
import 'package:frontend/features/pose/presentation/widgets/pose_search_bar.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import '../cubit/transition_cubit.dart';
import '../widgets/transition_card.dart';


class TransitionLibraryPage extends StatefulWidget {
  const TransitionLibraryPage({super.key});

  @override
  State<TransitionLibraryPage> createState() => _TransitionLibraryPageState();
}

class _TransitionLibraryPageState extends State<TransitionLibraryPage> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // Navigation
  void _navigateToTransitionPage(TransitionEntity transition) {
    context.goNamed(
      'transition-view',
      pathParameters: {'transitionId': transition.id},
      queryParameters: {'from': 'transition-library'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transitions")),
      body:
      BlocBuilder<PosesCubit, PosesState>(
        builder: (context, poseState) {
          return BlocBuilder<TransitionCubit, TransitionState>(
            builder: (context, transitionState) {
              if (poseState is! GetPosesSuccess || transitionState is! GetTransitionsSuccess) {
                return const Center(child: CircularProgressIndicator());
              }

              final poses = poseState.poses;
              final poseMap = { for (final p in poses) p.id: p };

              final allTransitions = transitionState.transitions;

              final filteredTransitions = _searchQuery.isEmpty
                  ? allTransitions
                  : allTransitions.where((t) {
                final from = poseMap[t.fromPoseId]?.displayName.toLowerCase() ?? '';
                final to = poseMap[t.toPoseId]?.displayName.toLowerCase() ?? '';
                return from.contains(_searchQuery.toLowerCase()) ||
                    to.contains(_searchQuery.toLowerCase());
              }).toList();

              return ListView.builder(
                itemCount: filteredTransitions.length,
                itemBuilder: (context, index) {
                  final t = filteredTransitions[index];
                  final fromPose = poseMap[t.fromPoseId];
                  final toPose = poseMap[t.toPoseId];

                  return TransitionCard(
                    transition: t,
                    fromPose: fromPose!,
                    toPose: toPose!,
                    onTap: () => _navigateToTransitionPage(t),
                  );
                },
              );
            },
          );
        },
      )
    );
  }
}
