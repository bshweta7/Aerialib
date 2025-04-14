// TODO this page will show all of the flows accessible to user, with filters for apparatus


import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/core/constants/constants.dart';

import 'package:frontend/pages/widgets/multi_selector.dart';
import 'package:frontend/pages/widgets/search_bar.dart';
import 'package:frontend/pages/widgets/media_display/media_utils.dart';

import 'package:frontend/cubit/auth_cubit.dart';
import 'package:frontend/cubit/flow_cubit.dart';
import 'package:frontend/pages/flows/widgets/flow_card.dart';

import 'package:frontend/models/flow_model.dart';
import 'package:frontend/pages/widgets/media_display/media_card.dart';



class FlowLibraryPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const FlowLibraryPage(),
      );
  const FlowLibraryPage({super.key});

  @override
  State<FlowLibraryPage> createState() => _FlowLibraryPageState();
}

class _FlowLibraryPageState extends State<FlowLibraryPage> {

  int _gridSize = 3; // Start at 0 and set during the first build
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

    context.read<FlowsCubit>().getAllFlows(token: user.user.token);

    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        print("Wifi Available");
        await context.read<FlowsCubit>().syncFlows(user.user.token);
        // TODO Sync flows when coming back to the page, even if there is no change in wifi connectivity -- accounts for adding a new flow and returning to the flow library (maybe ??)

      } else {
        print("No wifi available");
      }
    });
  }

  void changeGridSize(int amount) {
    // Detect current width and calculate a maximum grid size (column count)
    Size windowSize = MediaQuery.of(context).size;
    _gridSize = calculateNewGridSize(amount, _gridSize, windowSize, kDebugMode);
    setState(() {
      _gridSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Flow Library"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                changeGridSize(1);
              },
              tooltip: 'Decrease Image Size',
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                changeGridSize(-1);
              },
              tooltip: 'Increase Image Size',
            ),
          ],
        ),

        body: BlocBuilder<FlowsCubit, FlowsState>(
          builder: (context, state) {

            if (state is FlowLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (state is FlowError) {
              print("Error: State is Flow Error");
              return Center(
                child: Column(
                  children: [
                    const Text("State flow error"),
                    Text(state.error),
                  ],
                ),
              );
            }

            if (state is GetFlowsSuccess) {
              List<FlowModel> filteredFlows = state.flows.toList();
              print(filteredFlows);
              List<List<String>> posesInFilteredFlows = [[
                "/default/clock.jpg",
                "/default/man_in_the_moon.jpg"
              ]];

              // List<String> flowsNamesList = [];
              // List<String> mediaPathsList = [];
              //
              // for (int i = 0; i < filteredFlows.length; i++) {
              //   flowsNamesList.add(filteredFlows[i].name);
              //   mediaPathsList.add("http://localhost:8000/media/data"+filteredFlows[i].primaryImageUrl);
              // }

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
                                        // TODO update the flows visible
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
                                // TODO - add level column to flows table
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
                        FlowCardList(
                          flowsList: filteredFlows,
                          posesInFlowsList: posesInFilteredFlows,
                        ),

                      // MediaCard(
                      //   flow
                      // )
                        // PosesInFlowCard(posesInFlowsList: posesInFilteredFlows),
                        // SingleChildScrollView(
                        //   controller: _myScrollController,
                        //   child:
                        //   PoseMediaGrid( // TODO MAKE FLOW MEDIA GRID
                        //     filteredFlows,
                        //     _gridSize,
                        //     "",
                        //     "",
                        //   ),
                        //
                        // ),

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

                        // // Show add new flow button
                        // if (_areOptionsVisible) // Conditional rendering of other buttons
                        //   Positioned(
                        //     bottom: 180,
                        //     right: 20,
                        //     child: FloatingActionButton(
                        //       heroTag: 'newFlowFAB',
                        //       tooltip: 'Add new flow',
                        //       onPressed: () {
                        //         Navigator.push(context, AddNewFlowPage.route());
                        //       },
                        //       child: const Icon(CupertinoIcons.add),
                        //     ),
                        //   ),

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