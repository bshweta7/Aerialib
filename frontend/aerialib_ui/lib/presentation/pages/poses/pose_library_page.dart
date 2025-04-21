import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/conversions.dart';

import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';

import 'package:frontend/presentation/cubit/poses/poses_cubit.dart';
import 'package:frontend/presentation/pages/poses/pose_view_page.dart';
import 'package:frontend/presentation/widgets/media_display/media_grid/media_grid_utils.dart';
import 'package:frontend/presentation/widgets/functional_buttons/filters/pose_filter.dart';
import 'package:frontend/presentation/widgets/functional_buttons/scroll_to_top.dart';
import 'package:frontend/presentation/widgets/media_display/media_grid/media_grid.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/media_list.dart';
import 'package:frontend/presentation/widgets/functional_buttons/search_bar.dart';


import 'package:frontend/presentation/cubit/users/auth_cubit.dart';

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

  int _gridSize = 3; // Start at 0 and set during the first build
  int _gridSizeMax = 10; // TODO set this dynamically when building
  final _formKey = GlobalKey<FormState>(); // TODO is this able to be handled with cubit?

  // Filtering
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;

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

  void changeGridSize(int amount) {
    // Detect current width and calculate a maximum grid size (column count)
    Size windowSize = MediaQuery.of(context).size;
    _gridSize = calculateNewGridSize(amount, _gridSize, windowSize, kDebugMode);
    setState(() {
      _gridSize;
    });
  }

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

  List<MediaIconEntity> _filterPosesBySearch(List<PoseEntity> allPoses, String query) {
    if (query.isEmpty) {
      return posesToMediaIcons(allPoses);
    }
    final lowerCaseQuery = query.toLowerCase();
    final filtered = allPoses.where((pose) {
      return pose.name.toLowerCase().contains(lowerCaseQuery) ||
          (pose.description?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          pose.apparatus.toLowerCase().contains(lowerCaseQuery);
    }).toList();
    return posesToMediaIcons(filtered);
  }


  // Navigation
  void _navigateToMediaPage(MediaIconEntity mediaItem) {
    Navigator.push(
      context,
      PoseViewPage.route(mediaItem.data),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Poses"),
          // TODO - add page view options to actions.
          // actions: const [
          //   AddNewPoseButton(),
          //   SizedBox(width:8.0),
          // ]
        ),

        body: BlocBuilder<PosesCubit, PosesState>(
          builder: (context, state) {

            if (state is PoseLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (state is PoseError) {
              print("ERROR: State is Pose Error");
              print(state.message);
              return const Center(
                child: Column(
                  children: [
                    Text("State pose error"),
                  ],
                ),
              );
            }

            if (state is GetPosesSuccess) {
              // TODO move filtering to cubit?
              List<PoseEntity> filteredPoses = state.poses.where(
                    (elem) =>
                selectedApparatus.contains(elem.apparatus) &&
                    selectedLevels.contains(elem.level),
              ).toList();

              List<MediaIconEntity> filteredMediaIcons = posesToMediaIcons(filteredPoses);

              return Column(
                children: [
                  // Pose Filters
                  PoseFilters(
                    initialApparatus: selectedApparatus,
                    initialLevels: selectedLevels,
                    onApparatusChanged: _updateApparatusFilter,
                    onLevelsChanged: _updateLevelsFilter,
                  ),
                  // TODO consider "Sticky Behavior" for filter box scrolling (currently stationary)
                  // A sticky behavior means the filter section scrolls normally at the top but then "sticks" to a certain position as the user scrolls down the list of poses. Flutter's SliverAppBar with pinned: true can achieve a similar effect for app bar sections, but for a regular widget in the body, it's a bit more involved and might require using ScrollController and Transform.translate or custom Sliver widgets.

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SearchBarWidget(
                      onSearchChanged: _updateSearchQuery,
                      suggestionList: state.poses,
                    ),
                  ),

                  const SizedBox(height: 15,),

                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              // TODO Search bar goes here


                              // List poses
                              MediaList(
                                mediaItems: filteredMediaIcons, // TODO should i define a new list to hold search results?
                                onMediaTap: _navigateToMediaPage,
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