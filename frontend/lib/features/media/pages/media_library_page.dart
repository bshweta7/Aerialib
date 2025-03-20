import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/utils.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/media/cubit/media_cubit.dart';
import 'package:frontend/features/media/pages/upload_new_media_page.dart';
import 'package:frontend/core/utils/media_grid.dart';
// import 'package:frontend/features/medias/widgets/media_grid.dart';
// import 'package:frontend/features/media/widgets/media_card.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/multi_selector.dart';
import '../../../core/utils/search_bar.dart';


class MediaLibraryPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const MediaLibraryPage(),
      );
  const MediaLibraryPage({super.key});

  @override
  State<MediaLibraryPage> createState() => _MediaLibraryPageState();
}

class _MediaLibraryPageState extends State<MediaLibraryPage> {

  int _gridSize = 3; // Start at 0 and set during the first build
  int _gridSizeMax = 10; // TODO set this dynamically when building
  String _searchQuery = ''; // To store the current search query
  final _apparatusController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // TODO is this able to be handled with cubit?
  List<String> initialApparatus = Constants.apparatusOptions;
  List<int> initialLevels = Constants.levelOptions;
  bool _isContainerVisible = false; // Initially hidden
  final ScrollController _myScrollController = ScrollController();
  bool _areOptionsVisible = false; // Track visibility

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
// TODO Medias -> Media ?
    context.read<MediaCubit>().getAllMedia(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        print("Wifi Available");
        await context.read<MediaCubit>().syncMedia(user.user.token);

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


  // // Store the URLs for all the photos the app needs to download and cache
// Future<List> _getMediaList(List<MediaModel> medias) async {
//

//   List<String> thumbnailURLs = medias.map((media) => media.thumbnailURL).toList();
//   print("THUMBNAILS");
//   print(thumbnailURLs); // Output the list to verify.
//   return thumbnailURLs;

  // TODO

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Media Library"),
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

        body: BlocBuilder<MediaCubit, MediaState>(
          builder: (context, state) {

            if (state is MediaLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (state is MediaError) {
              print("Error: State is Media Error");
              return Center(
                child: Column(
                  children: [
                    const Text("State media error"),
                    Text(state.error),
                  ],
                ),
              );
            }

            if (state is GetMediaListSuccess) {
              final mediaList = state.mediaList.toList();
              // TODO FILTERING: final medias = state.medias.where(
              //                       (elem) =>
              //                   DateFormat('d').format(elem.dueAt) == DateFormat('d').format(selectedDate) &&
              //                       selectedDate.month == elem.dueAt.month &&
              //                       selectedDate.year == elem.dueAt.year
              //               ).toList();

              print("MEDIA FROM HOME PAGE");
              print(mediaList);

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

                      ],
                    ),
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
                          child: MediaGrid(
                            mediaList,
                            mediaList, // TODO THIS IS COMPLETELY WRONG!!! SEE POSE LIBRARY
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
                              tooltip: 'Reset filters',
                              onPressed: () {
                                // TODO implement reset filters
                                initialApparatus = Constants.apparatusOptions;
                                initialLevels = Constants.levelOptions;
                              },
                              child: const Icon(CupertinoIcons.refresh),
                            ),
                          ),

                        // Show add new media button
                        if (_areOptionsVisible) // Conditional rendering of other buttons
                          Positioned(
                            bottom: 180,
                            right: 20,
                            child: FloatingActionButton(
                              tooltip: 'Upload new media',
                              onPressed: () {
                                Navigator.push(context, UploadNewMediaPage.route());
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