import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/transitions/domain/transition_entity.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';

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
    return MainScaffold(
      currentIndex: 2, // TODO what do do here?
      appBar: AppBar(
          leading: const SmartBackButton(),
          title: const Text("Transitions"),
          //   TODO make an "add transition" button
          //      actions: [
          //   IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () {
          //     context.goNamed('add-new-pose',);
          //   },
          //   tooltip: 'Add a new pose',
          // ),

      ),
      body: BlocBuilder<PosesCubit, PosesState>(
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
