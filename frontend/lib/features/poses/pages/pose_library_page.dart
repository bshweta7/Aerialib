import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/poses/cubit/poses_cubit.dart';
import 'package:frontend/features/poses/pages/add_new_pose_page.dart';
import 'package:frontend/core/utils/media_grid.dart';
// import 'package:frontend/features/poses/widgets/media_grid.dart';
import 'package:frontend/features/poses/widgets/pose_card.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/multi_selector.dart';
import '../../../core/utils/search_bar.dart';


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
  final _apparatusController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // TODO is this able to be handled with cubit?
  List<String> initialApparatus = Constants.apparatusOptions;
  List<int> initialLevels = Constants.levelOptions;
  bool _isContainerVisible = false; // Initially hidden

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    context.read<PosesCubit>().getAllPoses(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        print("Wifi Available");
        await context.read<PosesCubit>().syncPoses(user.user.token);

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
      _gridSize;
    });
  } // TODO MOve this to media_grid.dart and have it all in one.

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

        // appBar: AppBar(
        //     title: const Text("My Poses"),
        //     actions: [
        //       IconButton(
        //           onPressed: () {
        //             Navigator.push(context, AddNewPosePage.route());
        //           },
        //           icon: const Icon(CupertinoIcons.add,
        //           )
        //       )
        //     ]
        // ),

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
              final poses = state.poses.toList();
              // TODO FILTERING: final poses = state.poses.where(
              //                       (elem) =>
              //                   DateFormat('d').format(elem.dueAt) == DateFormat('d').format(selectedDate) &&
              //                       selectedDate.month == elem.dueAt.month &&
              //                       selectedDate.year == elem.dueAt.year
              //               ).toList();

              print("POSES FROM HOME PAGE");
              print(poses);

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
                              icon: const Icon(CupertinoIcons.refresh),
                              onPressed: () {
                                // TODO Reset all filter states
                              },
                              tooltip: 'Reset filters',
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
                              tooltip: 'Toggle filters',
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
                                Row(
                                  children: [
                                    const Text(
                                      "Apparatus: ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    MultiSelect(
                                      options: Constants.apparatusOptions,
                                      initialValues: initialApparatus,
                                      getLabel: (String apparatus) {
                                        if (apparatus.isEmpty) {
                                          return apparatus; // Or return some default string if needed
                                        }
                                        return apparatus[0].toUpperCase() + apparatus.substring(1);
                                      },
                                      // getLabel: (String apparatus) => apparatus, // Simple string case
                                      onSelectionChanged: (List<String> selected) {
                                        print('Selected Apparatus: $selected');
                                        // Update your apparatus controller or state here
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          // const SnackBar(content: Text('Please select at least one apparatus'));
                                          return 'Please select at least one apparatus';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height:10),

                                // Level Filter
                                Row(
                                  children: [
                                    const Text(
                                      "Level: ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    MultiSelect<int>(
                                      options: Constants.levelOptions,
                                      initialValues: initialLevels,
                                      getLabel: (int level) => 'Level $level', // Format the label
                                      onSelectionChanged: (List<int> selected) {
                                        print('Selected Levels: $selected');
                                        // Update your levels state here
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
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

                        SizedBox(height:10),
                      ],
                    ),
                  ),

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
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Grid Size: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(CupertinoIcons.minus),
                                      onPressed: () {
                                        _changeGridSize(1);
                                      },
                                      tooltip: 'Decrease Image Size',
                                    ),

                                    IconButton(
                                      icon: const Icon(CupertinoIcons.add),
                                      onPressed: () {
                                        _changeGridSize(-1);
                                      },
                                      tooltip: 'Increase Image Size',
                                    )
                                  ],
                                ),
                              ],
                            ),

                            IconButton(
                              icon: const Icon(CupertinoIcons.up_arrow),
                              onPressed: () {
                                // TODO implement top of page
                              },
                              tooltip: 'Go to the top of the page',
                            )
                          ],
                        ),

                      ],
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(CupertinoIcons.minus),
                        onPressed: () {
                          _changeGridSize(1);
                        },
                        tooltip: 'Decrease Image Size',
                      ),

                      const Text("Adjust Grid Size"),

                      IconButton(
                        icon: const Icon(CupertinoIcons.add),
                        onPressed: () {
                          _changeGridSize(-1);
                        },
                        tooltip: 'Increase Image Size',

                      )


                    ],

                  ),

                  // TODO implement search
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0
                    ),
                    child: SearchBarWidget(
                      onSearchChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                          // Update your UI based on _searchQuery
                          print('Search query: $query');
                        });
                      },
                      onSearchSubmitted: () {
                        // Handle search submission (e.g., perform a search)
                        print('Search submitted!');
                      },
                    ),
                  ),

                  SizedBox(height: 15,),
                  // SearchBar(
                  //   controller: controller,
                  //   padding: const WidgetStatePropertyAll<EdgeInsets>(
                  //     EdgeInsets.symmetric(horizontal: 16.0),
                  //   ),
                  //   onTap: () {
                  //     controller.openView();
                  //   },
                  //   onChanged: (_) {
                  //     controller.openView();
                  //   },
                  //   leading: const Icon(Icons.search),
                  //   // trailing: <Widget>[
                  //   // Tooltip(
                  //   //   message: 'Change brightness mode',
                  //   //   child: IconButton(
                  //   //     isSelected: isDark,
                  //   //     onPressed: () {
                  //   //       setState(() {
                  //   //         isDark = !isDark;
                  //   //       });
                  //   //     },
                  //   //   icon: const Icon(Icons.wb_sunny_outlined),
                  //   //   selectedIcon: const Icon(Icons.brightness_2_outlined),
                  //   //   ),
                  //   // ),
                  // ],
                  // ),

                  Expanded(
                    child: MediaGrid(poses, _gridSize, "", "")
                    // TODO remove ""s
                  ),

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
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Grid Size: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(CupertinoIcons.minus),
                                      onPressed: () {
                                        _changeGridSize(1);
                                      },
                                      tooltip: 'Decrease Image Size',
                                    ),

                                    IconButton(
                                      icon: const Icon(CupertinoIcons.add),
                                      onPressed: () {
                                        _changeGridSize(-1);
                                      },
                                      tooltip: 'Increase Image Size',
                                    )
                                  ],
                                ),
                              ],
                            ),

                            IconButton(
                              icon: const Icon(CupertinoIcons.up_arrow),
                              onPressed: () {
                                // TODO implement top of page
                              },
                              tooltip: 'Go to the top of the page',
                            )
                          ],
                        ),

                      ],
                    ),
                  ),



                ],
              );
              // return Column(
              //     children: [
              //       Expanded(
              //         child: ListView.builder(
              //             itemCount: poses.length,
              //             itemBuilder: (context, index) {
              //               final pose = poses[index];
              //               return Row(
              //                 children: [
              //                   Expanded(
              //                     child: PoseCard(
              //                         color: pose.color,
              //                         headerText: pose.title,
              //                         descriptionText: pose.description
              //                     ),
              //                   ),
              //                   // Container(
              //                   //   height: 10,
              //                   //   width: 10,
              //                   //   decoration: BoxDecoration(
              //                   //     color: strengthenColor(
              //                   //       pose.color,
              //                   //       0.69,
              //                   //     ),
              //                   //     shape: BoxShape.circle,
              //                   //   ),
              //                   // ),
              //                   // Padding(
              //                   //   padding: const EdgeInsets.all(12.0),
              //                   //   child: Text(
              //                   //       DateFormat.jm().format(pose.dueAt),
              //                   //       style: const TextStyle(
              //                   //         fontSize: 17,
              //                   //       )
              //                   //   ),
              //                   // )
              //
              //                 ],
              //               );
              //             }
              //         ),
              //       )
              //     ]
              // );
            }
            return const SizedBox();

          },
        )
    );
  }
}