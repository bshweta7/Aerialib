import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/features/transitions/domain/transition_entity.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:frontend/features/transitions/presentation/cubit/transition_cubit.dart';
import 'package:frontend/features/transitions/presentation/widgets/transition_card.dart';
import 'package:frontend/shared/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import '../../../../shared/widgets/search_bar.dart';

class TransitionLibraryPage extends StatefulWidget {
  const TransitionLibraryPage({super.key});

  @override
  State<TransitionLibraryPage> createState() => _TransitionLibraryPageState();
}

class _TransitionLibraryPageState extends State<TransitionLibraryPage> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _filterMode = 'All'; // All | From | To | Name
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;

  void _updateSearchQuery(String query) {
    setState(() => _searchQuery = query);
  }

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
      currentIndex: 2,
      isScrollable: false,
      // scrollController: _scrollController,
      // isScrollToTopVisible: true,
      // isScrollbarVisible: true,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Transitions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.goNamed('add-new-transition'),
            tooltip: 'Add new transition',
          ),
        ],
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

              List<TransitionEntity> filteredTransitions = transitionState.transitions.where((t) {
                final from = poseMap[t.fromPoseId];
                final to = poseMap[t.toPoseId];
                if (from == null || to == null) return false;

                // Apply apparatus/level filters
                final targetPose = _filterMode == 'To'
                    ? to
                    : _filterMode == 'From'
                    ? from
                    : null;

                if (targetPose != null) {
                  if (!selectedApparatus.contains(targetPose.apparatus)) return false;
                  if (!selectedLevels.contains(targetPose.level?.floor())) return false;
                }

                final query = _searchQuery.toLowerCase();
                final matchesFrom = from.displayName.toLowerCase().contains(query);
                final matchesTo = to.displayName.toLowerCase().contains(query);
                final matchesName = t.name != null ?
                  t.name!.toLowerCase().contains(query) :
                  false;

                switch (_filterMode) {
                  case 'From': return matchesFrom;
                  case 'To': return matchesTo;
                  case 'Name': return matchesName;
                  case 'All':
                  default: return matchesFrom || matchesTo || matchesName;
                }
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: LibrarySearchBar<TransitionEntity>(
                            hintText: 'Search transitions...',
                            suggestions: filteredTransitions, // for internal match logic (can be empty if not using suggestions)
                            getDisplayText: (t) => t.name ?? "Unnamed Transition",
                            onSearchChanged: _updateSearchQuery,
                            // showSuggestions: false,
                          )

                          // child: TextField(
                          //   onChanged: _updateSearchQuery,
                          //   decoration: InputDecoration(
                          //     hintText: 'Search transitions...',
                          //     prefixIcon: const Icon(Icons.search),
                          //     suffixIcon: DropdownButton<String>(
                          //       value: _filterMode,
                          //       onChanged: (value) => setState(() => _filterMode = value!),
                          //       underline: const SizedBox(),
                          //       items: ['All', 'From', 'To', 'Name']
                          //           .map((mode) => DropdownMenuItem(value: mode, child: Text(mode)))
                          //           .toList(),
                          //     ),
                          //     filled: true,
                          //     fillColor: Colors.grey.shade100,
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(25),
                          //       borderSide: BorderSide.none,
                          //     ),
                          //   ),
                          // ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.filter_alt_outlined),
                          tooltip: 'Filter',
                          onPressed: () {
                            // TODO: open filter bottom sheet
                          },
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      children: [
                        if (filteredTransitions.isEmpty)
                          const Center(child: Text("No transitions match your filters."))
                        else
                          ListView.builder(
                            controller: _scrollController,
                            itemCount: filteredTransitions.length,
                            itemBuilder: (context, index) {
                              final t = filteredTransitions[index];
                              final from = poseMap[t.fromPoseId]!;
                              final to = poseMap[t.toPoseId]!;
                              return TransitionCard(
                                transition: t,
                                fromPose: from,
                                toPose: to,
                                onTap: () => _navigateToTransitionPage(t),
                              );
                            },
                          ),
                        // ScrollToTopButton(scrollController: _scrollController),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}