import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import '../../../../shared/widgets/filter_sheet.dart';
import '../../../../shared/widgets/search_bar.dart';


class PoseLibraryPage extends StatefulWidget {
  const PoseLibraryPage({super.key});

  @override
  State<PoseLibraryPage> createState() => _PoseLibraryPageState();
}

class _PoseLibraryPageState extends State<PoseLibraryPage> {

  final ScrollController _scrollController = ScrollController();

  // TODO GRID VIEW
  // int _gridSize = 3; // Start at 0 and set during the first build
  // int _gridSizeMax = 10; // TODO set this dynamically when building
  // final _formKey = GlobalKey<FormState>(); // TODO is this able to be handled with cubit?

  // Filtering
  final bool _showFilters = false;
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;

  // Search Bar
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initSync();
  }

  Future<void> _initSync() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    await context.read<PosesCubit>().syncPoses(token: user.user.token);
    if (!mounted) return;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // TODO GRID VIEW
  // void changeGridSize(int amount) {
  //   // Detect current width and calculate a maximum grid size (column count)
  //   Size windowSize = MediaQuery.of(context).size;
  //   _gridSize = calculateNewGridSize(amount, _gridSize, windowSize, kDebugMode);
  //   setState(() {
  //     _gridSize;
  //   });
  // }

  // Filtering
  void _updateApparatusFilter(List<String> newApparatus) {
    setState(() {
      selectedApparatus = newApparatus;
    });
  }

  void _updateLevelsFilter(List<int> newLevels) {
    setState(() {
      selectedLevels = newLevels;
    });
  }

  // TODO Search should result in multiple options that show up as filtered poses (low priority) Also fix flows library page
  // List<MediaIconEntity> _filterPosesBySearch(List<PoseEntity> allPoses, String query) {
  //   if (query.isEmpty) {
  //     return posesToMediaIcons(allPoses);
  //   }
  //   final lowerCaseQuery = query.toLowerCase();
  //   final filtered = allPoses.where((pose) {
  //     return pose.name.toLowerCase().contains(lowerCaseQuery) ||
  //         (pose.description?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
  //         pose.apparatus.toLowerCase().contains(lowerCaseQuery);
  //   }).toList();
  //   return posesToMediaIcons(filtered);
  // }


  // Navigation
  void _navigateToPosePage(MediaIconEntity mediaItem) {
    context.goNamed(
      'pose-view',
      pathParameters: {'poseId': mediaItem.data.id},
      queryParameters: {'from': 'pose-library'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        isScrollable: false,
        currentIndex: 2,
        appBar: AppBar(
          leading: const SmartBackButton(),
          title: const Text("Poses"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.goNamed('add-new-pose',);
              },
              tooltip: 'Add a new pose',
            ),
          ]
          // TODO three dots to show page view options and add new pose button
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.remove_circle_outline),
          //     onPressed: () {
          //       changeGridSize(1);
          //     },
          //     tooltip: 'Decrease Image Size',
          //   ),
          //   IconButton(
          //     icon: const Icon(Icons.add_circle_outline),
          //     onPressed: () {
          //       changeGridSize(-1);
          //     },
          //     tooltip: 'Increase Image Size',
          //   ),
          // ],
        ),

        body: BlocBuilder<PosesCubit, PosesState>(
          builder: (context, state) {

            if (state is PoseLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (state is PoseError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            if (state is GetPosesSuccess) {

              // Filtering
              List<PoseEntity> filteredPoses = state.poses.where((elem) {
                final matchesApparatus = selectedApparatus.map((e) => e.toLowerCase()).contains(elem.apparatus.toLowerCase());
                final matchesQuery = elem.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
                final matchesLevel = selectedLevels.contains(elem.level?.floor() ?? -1);
                return matchesApparatus && matchesQuery && matchesLevel;
              }).toList();

              List<MediaIconEntity> filteredMediaIcons = posesToMediaIcons(filteredPoses);

              // // Search suggestion list
              // final List<PoseEntity> sortedPoses = List<PoseEntity>.from(state.poses)
              //   ..sort((a, b) => a.slug.toLowerCase().compareTo(b.slug.toLowerCase()));
              // // TODO - decide if search list should only show filtered poses or all poses

              return Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      children: [

                        // Search Bar
                        Expanded(
                          child: LibrarySearchBar<PoseEntity>(
                            hintText: 'Search Poses',
                            suggestions: filteredPoses,
                            getDisplayText: (pose) => pose.displayName,
                            onSearchChanged: (query) => setState(() => _searchQuery = query),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Filter Icon Button
                        IconButton(
                          icon: const Icon(Icons.filter_alt_outlined),
                          tooltip: 'Show filters',
                          onPressed: () {
                            FiltersSheet.show<String>(
                              context: context,
                              filterOptions: {
                                'Apparatus': Constants.apparatusOptions,
                                'Level': Constants.levelOptions.map((e) => e.toString()).toList(),
                              },
                              selectedFilters: {
                                'Apparatus': selectedApparatus,
                                'Level': selectedLevels.map((e) => e.toString()).toList(),
                              },
                              onFilterChanged: (category, values) {
                                setState(() {
                                  if (category == 'Apparatus') {
                                    selectedApparatus = values;
                                  } else if (category == 'Level') {
                                    selectedLevels = values.map(int.parse).toList();
                                  }
                                });
                              },
                              // labelBuilder: (category, value) {
                              //   if (category == 'Level') {
                              //     final intVal = int.tryParse(value) ?? -1;
                              //     if (intVal == 0) return 'Intro';
                              //     if (intVal == -1) return 'Other';
                              //     return 'Level $intVal';
                              //   }
                              //   return value;
                            );
                            // PoseFiltersSheet.showFilterSheet(
                            //   context: context,
                            //   selectedApparatus: selectedApparatus,
                            //   selectedLevels: selectedLevels,
                            //   onApparatusChanged: _updateApparatusFilter,
                            //   onLevelsChanged: _updateLevelsFilter,
                            // );
                          },
                        ),
                      ],
                    ),
                  ),

                  if (selectedApparatus.length < Constants.apparatusOptions.length ||
                      selectedLevels.length < Constants.levelOptions.length)
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
                              });
                            },
                            child: const Text('Clear All'),
                          )
                        ],
                      ),
                    ),

                  // const SizedBox(height: 15),

                  Expanded(
                    child: Stack(
                      children: [
                        if (filteredMediaIcons.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                              child: Text(
                                "No poses, try changing the filters",
                                style: Theme.of(context).textTheme.bodyMedium
                              ),
                            ),
                          )
                        else

                          // TODO update Media List to have scrollbar in it.
                          Padding(
                            padding: const EdgeInsets.only(right: 1), // optional: gives scrollbar space
                            child: MediaList(
                              mediaItems: filteredMediaIcons,
                              onMediaTap: _navigateToPosePage,
                              scrollController: _scrollController,
                            ),
                          ),
                          // MediaList(
                          //   mediaItems: filteredMediaIcons,
                          //   onMediaTap: _navigateToPosePage,
                          //   scrollController: _scrollController,
                          // ),

                        // Scroll to top floating button
                        ScrollToTopButton(scrollController: _scrollController), // Add the button

                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        )
    );
  }
}