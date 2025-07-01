import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/transitions/domain/transition_entity.dart';
import 'package:frontend/features/pose/presentation/cubit/poses_cubit.dart';
import 'package:frontend/features/transitions/presentation/cubit/transition_cubit.dart';
import 'package:frontend/features/transitions/presentation/widgets/transition_card.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import '../../../../shared/widgets/filter_sheet.dart';
import '../../../../shared/widgets/search_bar.dart';

class TransitionLibraryPage extends StatefulWidget {
  const TransitionLibraryPage({super.key});

  @override
  State<TransitionLibraryPage> createState() => _TransitionLibraryPageState();
}

class _TransitionLibraryPageState extends State<TransitionLibraryPage> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _searchMode = 'All';
  List<String> selectedFilterMode = ['From', 'To'];
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;
  List<String> selectedType = Constants.transitionTypeOptions;

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
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Transitions"),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add),
        //     onPressed: () => context.goNamed('add-new-transition'),
        //     tooltip: 'Add new transition',
        //   ),
        // ],
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

              /// Filter Entities
              List<TransitionEntity> filteredTransitions = transitionState.transitions.where((t) {
                final from = poseMap[t.fromPoseId];
                final to = poseMap[t.toPoseId];
                if (from == null || to == null) return false;

                final targetPose = selectedFilterMode == 'From' ? from : to;

                if (!selectedApparatus.contains(targetPose.apparatus)) return false;
                if (!selectedLevels.contains(targetPose.level?.floor())) return false;

                final selectedTypesNormalized = selectedType.map((e) => e.toLowerCase()).toList();
                if (!selectedType.contains((t.transitionType ?? 'unspecified').toLowerCase())) return false;

                final query = _searchQuery.toLowerCase();
                final matchesFrom = from.displayName.toLowerCase().contains(query);
                final matchesTo = to.displayName.toLowerCase().contains(query);
                final matchesName = t.name?.toLowerCase().contains(query) ?? false;
                final matchesType = t.transitionType?.toLowerCase().contains(query) ?? false;

                switch (_searchMode) {
                  case 'From': return matchesFrom;
                  case 'To': return matchesTo;
                  case 'Name': return matchesName;
                  default: return matchesFrom || matchesTo || matchesName || matchesType;
                }
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      children: [
                        
                        /// Search Bar
                        Expanded(
                          child: LibrarySearchBar<TransitionEntity>(
                            hintText: 'Search Transitions',
                            suggestions: filteredTransitions,
                            getDisplayText: (t) => t.name ?? "Unnamed Transition",
                            onSearchChanged: (query) => setState(() => _searchQuery = query),
                            dropdownOptions: const ["All", "From", "To", "Name"],
                            onDropdownChanged: (val) => setState(() => _searchMode = val),
                          ),
                        ),
                        
                        const SizedBox(width: 10),

                        /// Filter Icon Button
                        IconButton(
                          icon: const Icon(Icons.filter_alt_outlined),
                          tooltip: 'Show filters',
                          onPressed: () {
                            FiltersSheet.show<String>(
                              context: context,
                              filterOptions: {
                                'Apply To': ['From', 'To'],
                                'Level': Constants.levelOptions.map((e) => e.toString()).toList(),
                                'Apparatus': Constants.apparatusOptions,
                                'Transition Type': Constants.transitionTypeOptions,
                              },
                              selectedFilters: {
                                'Apply To': selectedFilterMode,
                                'Apparatus': selectedApparatus,
                                'Transition Type': selectedType,
                                'Level': selectedLevels.map((e) => e.toString()).toList(),
                              },
                              onFilterChanged: (category, values) {
                                setState(() {
                                  if (category == 'Apparatus') {
                                    selectedApparatus = values;
                                  } else if (category == 'Level') {
                                    selectedLevels = values.map(int.parse).toList();
                                  } else if (category == 'Apply To' && values.isNotEmpty) {
                                    selectedFilterMode = values;
                                  } else if (category == 'Transition Type' && values.isNotEmpty) {
                                    selectedType = values;
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  /// Show Active Filters
                  if (selectedApparatus.length < Constants.apparatusOptions.length ||
                      selectedLevels.length < Constants.levelOptions.length ||
                      selectedType.length < Constants.transitionTypeOptions.length ||
                      selectedFilterMode.length < 2
                  )
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Tooltip(
                            message: '${selectedApparatus.length} Apparatus, ${selectedLevels.length} Levels',
                            child: Text(
                              'Filters: ${selectedApparatus.length + selectedLevels.length} Active',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedApparatus = Constants.apparatusOptions;
                                selectedLevels = Constants.levelOptions;
                                selectedFilterMode = ['From', 'To'];
                                selectedType = Constants.transitionTypeOptions;
                              });
                            },
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                    ),

                  Expanded(
                    child: Stack(
                      children: [
                        if (filteredTransitions.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                "No transitions match your filters",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          )
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
