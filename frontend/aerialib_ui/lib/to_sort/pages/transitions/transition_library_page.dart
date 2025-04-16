import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/to_sort/cubit/auth_cubit.dart';
import 'package:frontend/to_sort/cubit/transition_cubit.dart';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/to_sort/pages/widgets/multi_selector.dart';
import 'package:frontend/to_sort/pages/widgets/search_bar.dart';

import 'package:frontend/to_sort/models/transition_model.dart';

class TransitionLibraryPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(
        builder: (context) => const TransitionLibraryPage(),
      );
  const TransitionLibraryPage({super.key});

  @override
  State<TransitionLibraryPage> createState() => _TransitionLibraryPageState();
}

class _TransitionLibraryPageState extends State<TransitionLibraryPage> {

  int _gridSize = 3; // Start at 0 and set during the first build
  int _gridSizeMax = 10; // TODO set this dynamically when building
  String _searchQuery = ''; // To store the current search query
  final _formKey = GlobalKey<FormState>(); // TODO is this able to be handled with cubit?
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<String> selectedShareStatus = Constants.shareOptions; // TODO
  bool _isContainerVisible = false; // Initially hidden
  final ScrollController _myScrollController = ScrollController();
  bool _areOptionsVisible = false; // Track visibility

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    context.read<TransitionCubit>().getAllTransition(token: user.user.token);

    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        print("Wifi Available");
        await context.read<TransitionCubit>().syncTransition(user.user.token);

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
  } // TODO Move this to media_utils.dart


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Transition Library"),
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

        body: BlocBuilder<TransitionCubit, TransitionState>(
          builder: (context, state) {

            if (state is TransitionLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }

            if (state is TransitionError) {
              print("Error: State is Transition Error");
              return Center(
                child: Column(
                  children: [
                    const Text("State transition error"),
                    Text(state.error),
                  ],
                ),
              );
            }

            if (state is GetTransitionListSuccess) {
              final transitionList = state.transitionList.toList();

              // List<TransitionModel> filteredTransition = state.transitionList.where(
              //       (elem) =>
              //   selectedApparatus.contains(elem.apparatus)
              //       // && selectedShareStatus.contains(elem.apparatus), // TODO USER - needs more work
              // ).toList();


              return Column(
                children: [

                  // TODO Move floating buttons to be attached to entire thing, not just transition box
                  Expanded(
                    child: Stack(
                      children: [
                        // TODO : need to update transition Grid to take transition not poseModel
                        // SingleChildScrollView(
                        //   controller: _myScrollController,
                        //   child: TransitionGrid(
                        //     filteredTransition,
                        //     _gridSize,
                        //     "",
                        //     "",
                        //   ),
                        // ),

                        Positioned(
                          bottom: 20,
                          right: 20,

                          // Options Button
                          // TODO Make a Floating Action Button widget so its easy to remember the hero tag
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
                                selectedShareStatus = Constants.shareOptions;
                              },
                              child: const Icon(CupertinoIcons.refresh),
                            ),
                          ),

                        // // Show add new transition button
                        // if (_areOptionsVisible) // Conditional rendering of other buttons
                        //   Positioned(
                        //     bottom: 180,
                        //     right: 20,
                        //     child: FloatingActionButton(
                        //       heroTag: 'newTransitionFAB',
                        //       tooltip: 'Upload new transition',
                        //       onPressed: () {
                        //         Navigator.push(context, UploadNewTransitionPage.route());
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
                              tooltip: 'Scroll to the top of the page',
                              onPressed: () {
                                _myScrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
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