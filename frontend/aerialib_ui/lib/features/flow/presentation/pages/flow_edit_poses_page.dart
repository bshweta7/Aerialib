import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/core/constants/constants.dart';

import 'package:frontend/features/flow/domain/entities/flow_entity.dart';
import 'package:frontend/features/flow/domain/entities/flow_pose_entity.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';

import 'package:frontend/features/flow/presentation/cubit/flows_cubit.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';
import 'package:frontend/features/pose/presentation/pages/pose_view_sheet.dart';
import 'package:frontend/shared/widgets/media_display/cards/list_card.dart';
import 'package:frontend/features/pose/presentation/widgets/pose_search_bar.dart';
import 'package:frontend/features/flow/presentation/widgets/flow_help_dialog.dart';
import 'package:frontend/shared/features/navigation/widgets/nav_bar.dart';
import 'package:frontend/features/pose/presentation/widgets/pose_filter_sheet.dart';

import '../widgets/flow_pose_card.dart';


class FlowEditPosesPage extends StatefulWidget {
  final FlowEntity flow;

  const FlowEditPosesPage({super.key, required this.flow});

  @override
  State<FlowEditPosesPage> createState() => _FlowEditPosesPageState();
}

class _FlowEditPosesPageState extends State<FlowEditPosesPage> {
  late List<FlowPoseEntity> poses;
  String _searchQuery = '';
  bool _showSwipeHint = true;
  final TextEditingController _textController = TextEditingController();

  // Filtering
  final bool _showFilters = false;
  List<String> selectedApparatus = Constants.apparatusOptions;
  List<int> selectedLevels = Constants.levelOptions;

  @override
  void initState() {
    super.initState();
    poses = List.from(widget.flow.flowPoses);
    // TODO sync here!!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlowsCubit>().startEditingFlow(widget.flow);
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
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _addPoseToFlow(PoseEntity pose) {
    final newFlowPose = FlowPoseEntity(
      id: const Uuid().v4(),
      flowId: widget.flow.id,
      pose: pose,
      poseOrder: poses.length, // TODO make it able to add anywhere in flow
      isSynced: 0,
    );

    setState(() {
      poses.add(newFlowPose);
      _searchQuery = '';
    });
  }

  void _addPoseAtIndex(int index, PoseEntity pose) {
    final newFlowPose = FlowPoseEntity(
      id: const Uuid().v4(),
      flowId: widget.flow.id,
      pose: pose,
      poseOrder: poses.length, // temporary; will be fixed below
      isSynced: 0,
    );

    setState(() {
      // Step 1: Add to end
      poses.add(newFlowPose);

      // Step 2: Remove from end and insert right after the given index
      final inserted = poses.removeLast();
      poses.insert(index, inserted);

      // Step 3: Recalculate poseOrder
      _recalculatePoseOrders();

      // Clear search
      _searchQuery = '';
    });
  }


  void _recalculatePoseOrders() {
    for (int i = 0; i < poses.length; i++) {
      poses[i] = poses[i].copyWith(poseOrder: i);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;

      final item = poses.removeAt(oldIndex);
      poses.insert(newIndex, item);

      _showSwipeHint = false;

      _recalculatePoseOrders();
    });
  }

  Future<void> _saveFlow() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    final updatedFlow = widget.flow.copyWith(flowPoses: poses);

    log("[FlowEditPosesPage] Updating flow poses... ");
    context.read<FlowsCubit>().updateFlowPoses(poses);
    await context.read<FlowsCubit>().saveFlowPoses(token: user.user.token);
    await context.read<FlowsCubit>().getAllFlows(token: user.user.token);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Saving flow...')),
    // );


    log("[FlowEditPosesPage] Navigating to FlowViewPage with ${updatedFlow.flowPoses.length} poses");
    await Future.delayed(const Duration(milliseconds: 200));
    context.goNamed(
      'flow-view',
      pathParameters: {'flowId': updatedFlow.id},
      // queryParameters: {'from': 'flow-edit-poses'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlowsCubit, FlowsState>(
      listener: (context, state) {
        if (state is EditFlowState && state.saveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flow saved successfully!')),
          );
        }
        if (state is EditFlowState && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving flow: ${state.errorMessage}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // leading: const SmartBackButton(), // TODO before going back, UPDATE THE CUBIT STATE!
          title: const Text('Edit Poses'),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: 'How to use this page',
              onPressed: () => FlowHelpDialog.show(context),
            ),
          ],
        ),
        body: BlocBuilder<FlowsCubit, FlowsState>(
          builder: (context, state) {
            if (state is FlowLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FlowError) {
              return Center(child: Text('Failed to load poses'));
            }

            if (state is EditFlowState) {
              final availablePoses = state.availablePoses;

              if (availablePoses.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } // TODO thats not right....

              // Filtering
              List<PoseEntity> filteredPoses = state.availablePoses.where(
                    (elem) =>
                selectedApparatus.map((e) => e.toLowerCase()).contains(elem.apparatus.toLowerCase())
                    // selectedLevels.contains(elem.level.floor()),
              ).toList();

              // Search suggestion list
              final List<PoseEntity> sortedFilteredPoses = List<PoseEntity>.from(filteredPoses)
                ..sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
              // TODO - decide if search list should only show filtered poses or all poses


              return Column(
                children: [
                  // TODO allow multiselect from pose library

                  // /// Search Bar
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  //   child: PoseSearchBarWidget(
                  //     onSearchChanged: _updateSearchQuery,
                  //     suggestionList: availablePoses,
                  //     onSuggestionTapped: _addPoseToFlow,
                  //     hintText: 'Add new pose',
                  //     // fromPage: 'flow-edit-poses', // TODO may need to be null, or pop if needed? Otherwise, this isn't a problem if the search bar shows pop up modal - might need a second option to show the modal and not the full page?
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      children: [

                        // Search Bar
                        Expanded(
                          child: PoseSearchBarWidget(
                            onSearchChanged: _updateSearchQuery,
                            suggestionList: sortedFilteredPoses,
                            onSuggestionTapped: _addPoseToFlow,
                            hintText: 'Add new pose',
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Filter Icon Button
                        IconButton(
                          icon: const Icon(Icons.filter_alt_outlined),
                          tooltip: 'Show filters',
                          onPressed: () {
                            PoseFiltersSheet.showFilterSheet(
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

                  /// Active filters
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

                  if (poses.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 20, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Add poses using the search bar. \n'
                                    'Tap the icon in the top right for help.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // TODO add filter or better add flow mechanism

                  // TODO light bulb on right side of each one that opens the list of poses you can transition to from the current pose (icon only shows up if there are known transitions). if clicked it drops down and creates a horizontal sliding list of images and names.
                  Expanded(
                    child: ReorderableListView(
                      buildDefaultDragHandles: false,
                      padding: const EdgeInsets.only(bottom: 75), // To avoid FAB overlap
                      onReorder: _onReorder,
                      children: poses.map((flowPose) {
                        return Container(
                            key: ValueKey(flowPose.id),
                        child: ReorderableDragStartListener(
                          index: poses.indexOf(flowPose),
                          child: Dismissible(
                          key: ValueKey(flowPose.id),
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              final removedPose = flowPose;
                              final removedIndex = poses.indexWhere((p) => p.id == removedPose.id);

                              setState(() {
                                poses.removeAt(removedIndex);
                                _showSwipeHint = false;
                                for (int i = 0; i < poses.length; i++) {
                                  poses[i] = poses[i].copyWith(poseOrder: i);
                                }
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${removedPose.pose.slug} removed'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      setState(() {
                                        poses.insert(removedIndex, removedPose);
                                        for (int i = 0; i < poses.length; i++) {
                                          poses[i] = poses[i].copyWith(poseOrder: i);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            child: FlowPoseCard(
                              flowPose: flowPose,
                              searchBarBuilder: (context, index) {
                                return PoseSearchBarWidget(
                                  onSearchChanged: _updateSearchQuery,
                                  suggestionList: sortedFilteredPoses,
                                  onSuggestionTapped: (pose) => _addPoseAtIndex(index, pose),
                                  hintText: 'Add new pose',
                                );
                              },
                              // PoseSearchBarWidget(
                              //   onSearchChanged: _updateSearchQuery,
                              //   suggestionList: sortedFilteredPoses,
                              //   onSuggestionTapped: _addPoseToFlow,
                              //   hintText: 'Add new pose',
                              // ),
                            )
                          ),
                        )
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 10), // for FAB padding
                ],
              );
            }
            return const SizedBox(); // fallback
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SizedBox(
            width: double.infinity, // Full width of the screen
            child: FloatingActionButton.extended(
              onPressed: _saveFlow,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: const NavBar(currentIndex: 1),
      ),
    );
  }
}
