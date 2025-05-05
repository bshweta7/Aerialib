import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/conversions.dart';

import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';

import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/cubit/users/auth_cubit.dart';

import 'package:frontend/presentation/pages/poses/pose_details_page.dart';
import 'package:frontend/presentation/pages/poses/add_new_pose_page.dart';

import 'package:frontend/presentation/widgets/filters/pose_filter_screen.dart';
import 'package:frontend/presentation/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/media_list.dart';
import 'package:frontend/presentation/widgets/search_bars/pose_search_bar.dart';


class PoseLibraryPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const PoseLibraryPage(),
      );
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
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;
  bool _showFilters = false;

  // Search Bar
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<PosesCubit>().getAllPoses(token: user.user.token);
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

  // Search Bar
  void _updateSearchQuery(String newQuery) {
    print(newQuery);
    setState(() {
      _searchQuery = newQuery;
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
    Navigator.push(
      context,
      PoseDetailsPage.route(mediaItem.data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Poses"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, AddNewPosePage.route());
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
              List<PoseEntity> filteredPoses = state.poses.where(
                    (elem) =>
                selectedApparatus.contains(elem.apparatus) &&
                    selectedLevels.contains(elem.level.floor()),
              ).toList();

              List<MediaIconEntity> filteredMediaIcons = posesToMediaIcons(filteredPoses);

              // Search suggestion list
              final List<PoseEntity> sortedPoses = List<PoseEntity>.from(state.poses)
                ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
              // TODO - decide if search list should only show filtered poses or all poses

              return Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      children: [

                        // Search Bar
                        Expanded(
                          child: PoseSearchBarWidget(
                            hintText: 'Search Poses',
                            onSearchChanged: _updateSearchQuery,
                            suggestionList: sortedPoses,
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Filter Icon Button
                        IconButton(
                          icon: const Icon(Icons.filter_alt_outlined),
                          tooltip: _showFilters
                              ? 'Hide filters'
                              : 'Show filters',
                          onPressed: () {
                            PoseFilters.showFilterSheet(
                              context: context,
                              selectedApparatus: selectedApparatus,
                              selectedLevels: selectedLevels,
                              onApparatusChanged: _updateApparatusFilter,
                              onLevelsChanged: _updateLevelsFilter,
                            );
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
                        SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              // List poses
                              MediaList(
                                mediaItems: filteredMediaIcons,
                                onMediaTap: _navigateToPosePage,
                              ),
                            ],
                          )
                        ),

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