import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/widgets/media_display/pose_grid.dart';
import 'package:frontend/core/widgets/multi_selector.dart';
import 'package:frontend/core/widgets/search_bar.dart';

import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/poses/cubit/poses_cubit.dart';
import 'package:frontend/features/poses/pages/add_new_pose_page.dart';

import 'package:frontend/models/pose_model.dart';

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

  int _gridSize = 3; // Start at 0 and set during the first build
  int _gridSizeMax = 10; // TODO set this dynamically when building
  String _searchQuery = ''; // To store the current search query
  final _formKey = GlobalKey<FormState>(); // TODO is this able to be handled with cubit?
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;
  bool _isContainerVisible = false; // Initially hidden
  final ScrollController _myScrollController = ScrollController();
  bool _areOptionsVisible = false; // Track visibility

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    context.read<PosesCubit>().getAllPoses(token: user.user.token);

    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        print("Wifi Available");
        await context.read<PosesCubit>().syncPoses(user.user.token);
        // TODO Sync poses when coming back to the page, even if there is no change in wifi connectivity -- accounts for adding a new pose and returning to the pose library (maybe ??)

      } else {
        print("No wifi available");
      }
    });
  }

  // Function to handle changing the size of the photo grid
  void _changeGridSize(int amount) {
    // Make sure the grid size can't go below 1 or above the max size

    if (_gridSize > 10) {
      amount *= kIsWeb ? 2 : 1;
    }

    if (amount < 0) {
      if (_gridSize + amount <= 0) {
        _gridSize = 1;
      } else {
        _gridSize += amount;
      }
    } else if (amount > 0) {
      if (_gridSize + amount >= _gridSizeMax) {
        _gridSize = _gridSizeMax;
      } else {
        _gridSize += amount;
      }
    }
    setState(() {
      _gridSize; // TODO should this be cubit-ified?
    });
  } // TODO Move this to utils.dart


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Pose Library"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                _changeGridSize(1);
              },
              tooltip: 'Decrease Image Size',
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                _changeGridSize(-1);
              },
              tooltip: 'Increase Image Size',
            ),
          ],
        ),

        body: BlocBuilder<PosesCubit, PosesState>(
          builder: (context, state) {

            if (state is PoseLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (state is PoseError) {
              print("Error: State is Pose Error");
              return Center(
                child: Column(
                  children: [
                    const Text("State pose error"),
                    Text(state.error),
                  ],
                ),
              );
            }

            if (state is GetPosesSuccess) {
              List<PoseModel> filteredPoses = state.poses.where(
                    (elem) =>
                selectedApparatus.contains(elem.apparatus) &&
                    selectedLevels.contains(elem.level),
              ).toList();

              // print("AAACK");
              // print(poses);
              // print(filteredPoses);

              // List<String> posesNamesList = [];
              // List<String> mediaPathsList = [];
              //
              // for (int i = 0; i < filteredPoses.length; i++) {
              //   posesNamesList.add(filteredPoses[i].name);
              //   mediaPathsList.add("http://localhost:8000/media/data"+filteredPoses[i].primaryImageUrl);
              // }

              // TODO REMOVE THE NAMES LIST ABOVE

                //       media.add(Media(
                //         responseJson[i]["media_id"].toString(), MediaType.photo,
                //         serverAddress + "/api/v1/media/" + responseJson[i]["media_id"].toString() + '/thumbnail',
                //         serverAddress + "/api/v1/media/" + responseJson[i]["media_id"].toString() + '/media',
                //       ));
                //       media[i].filename = responseJson[i]["filename"];
                //       media[i].takenTimestamp = (responseJson[i]["date_taken"] != null) ? DateTime.parse(responseJson[i]["date_taken"]) : DateTime.now();
                //     }

              // print("POSES FROM HOME PAGE");
              // print(poses);
              // print("NAMES");
              // print(posesNamesList);

              return Column(
                children: [

                  // Filters Section
                  Container(
                    width: double.infinity, // Expand horizontally
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Filters",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              icon: Icon(_isContainerVisible
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down), // Change icon based on visibility
                              onPressed: () {
                                setState(() {
                                  _isContainerVisible = !_isContainerVisible; // Toggle visibility
                                });
                              },
                              tooltip: 'Show or hide filter options',
                            ),
                          ],
                        ),
                        if (_isContainerVisible) // Conditional rendering
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Apparatus Filter
                                Wrap( // Changed to Wrap
                                  alignment: WrapAlignment.start,
                                  spacing: 8.0, // Space between children horizontally
                                  runSpacing: 4.0, // Space between lines vertically
                                  children: [
                                    const Text(
                                      "Apparatus:   ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    MultiSelect(
                                      options: Constants.apparatusOptions,
                                      initialValues: selectedApparatus,
                                      getLabel: (String apparatus) {
                                        if (apparatus.isEmpty) {
                                          return apparatus; // Or return some default string if needed
                                        }
                                        return apparatus[0].toUpperCase() + apparatus.substring(1);
                                      },
                                      // getLabel: (String apparatus) => apparatus, // Simple string case
                                      onSelectionChanged: (List<String> selected) {
                                        // TODO update the poses visible
                                        print('Selected Apparatus: $selected');
                                        setState(() {
                                          selectedApparatus = selected;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          const SnackBar(content: Text('Please select at least one apparatus'));
                                          return 'Please select at least one apparatus';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height:10),

                                // Level Filter
                                Wrap( // Changed to Wrap
                                  alignment: WrapAlignment.start,
                                  spacing: 8.0, // Space between children horizontally
                                  runSpacing: 4.0, // Space between lines vertically
                                  children: [
                                    const Text(
                                      "Level:   ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    MultiSelect<int>(
                                      options: Constants.levelOptions,
                                      initialValues: selectedLevels,
                                      getLabel: (int level) => 'Level $level',
                                      // TODO Format level 0 to intro
                                      // TODO should level even be an int? consider "level 1+" terminology
                                      onSelectionChanged: (List<int> selected) {
                                        print('Selected Levels: $selected');
                                        setState(() {
                                          selectedLevels = selected;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          const SnackBar(content: Text('Please select at least one level'));
                                          return 'Please select at least one level';
                                        }
                                        return null;
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(height:10),

                              ],
                            ),
                          ),

                      ],
                    ),
                  ),

                  // TODO implement search
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0
                    ),
                    child: SearchBarWidget(
                      // suggestionList: ['Test 1', 'Test 2', 'Test 3'],
                      onSearchChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                          // Update your UI based on _searchQuery
                          SnackBar(content: Text('Search query: $query'));
                        });
                      },
                      onSearchSubmitted: () {
                        // Handle search submission (e.g., perform a search)
                        const SnackBar(content: Text('Search submitted!'));
                      },
                    ),
                  ),

                  const SizedBox(height: 15,),

                  // TODO Move floating buttons to be attached to entire thing, not just media box
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          controller: _myScrollController,
                          child: PoseGrid(
                            filteredPoses,
                            _gridSize,
                            "",
                            "",
                          ),

                        ),

                        Positioned(
                          bottom: 20,
                          right: 20,

                          // Options Button
                          child: FloatingActionButton(
                            heroTag: 'pageOptionsFAB',
                            tooltip: 'Open page options',
                            onPressed: () {
                              setState(() {
                                _areOptionsVisible = !_areOptionsVisible; // Toggle visibility
                              });
                            },
                            child: const Icon(Icons.settings),
                          ),
                        ),

                        // Show refresh filters button
                        if (_areOptionsVisible) // Conditional rendering of other buttons
                          Positioned(
                            bottom: 260,
                            right: 20,
                            child: FloatingActionButton(
                              heroTag: 'resetFiltersFAB',
                              tooltip: 'Reset filters',
                              onPressed: () {
                                // TODO implement reset filters
                                selectedApparatus = Constants.apparatusOptions;
                                selectedLevels = Constants.levelOptions;
                              },
                              child: const Icon(CupertinoIcons.refresh),
                            ),
                          ),

                        // Show add new pose button
                        if (_areOptionsVisible) // Conditional rendering of other buttons
                          Positioned(
                            bottom: 180,
                            right: 20,
                            child: FloatingActionButton(
                              heroTag: 'newPoseFAB',
                              tooltip: 'Add new pose',
                              onPressed: () {
                                Navigator.push(context, AddNewPosePage.route());
                              },
                              child: const Icon(CupertinoIcons.add),
                            ),
                          ),

                        // Show scroll to top of page button
                        if (_areOptionsVisible)
                          Positioned(
                            bottom: 100, // Adjust position as needed to prevent overlap
                            right: 20,
                            child: FloatingActionButton(
                              heroTag: 'scrollTopFAB',
                              onPressed: () {
                                _myScrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              tooltip: 'Scroll to the top of the page',
                              child: const Icon(CupertinoIcons.arrow_up),
                            ),


                          ),
                      ],
                    ),
                  )

                ],
              );
            }
            return const SizedBox();
          },
        )
    );
  }
}