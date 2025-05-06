import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/pages/flows/flow_library_page.dart';
import 'package:frontend/presentation/pages/flows/flow_view_page.dart';
// import 'package:frontend/to_sort/pages/flows/flow_view_page.dart';
import 'package:uuid/uuid.dart';

import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/flow_pose_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';

import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/widgets/search_bars/pose_search_bar.dart';

import '../../cubit/users/auth_cubit.dart';
import '../../widgets/media_display/media_list/list_card.dart';
import '../poses/pose_view_page.dart';

class FlowEditPosesPage extends StatefulWidget {
  final FlowEntity flow;

  const FlowEditPosesPage({super.key, required this.flow});

  static MaterialPageRoute route(FlowEntity flow) {
    return MaterialPageRoute(
      builder: (context) => FlowEditPosesPage(flow: flow),
    );
  }

  @override
  State<FlowEditPosesPage> createState() => _FlowEditPosesPageState();
}

class _FlowEditPosesPageState extends State<FlowEditPosesPage> {
  late List<FlowPoseEntity> poses;
  String _searchQuery = '';
  bool _showSwipeHint = true;
  final TextEditingController _textController = TextEditingController();


  @override
  void initState() {
    super.initState();
    poses = List.from(widget.flow.poses);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlowsCubit>().startEditingFlow(widget.flow);
    });

  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _addPoseToFlow(PoseEntity pose) {
    final newFlowPose = FlowPoseEntity(
      id: const Uuid().v6(),
      flowId: widget.flow.id,
      pose: pose,
      poseOrder: poses.length,
    );

    setState(() {
      poses.add(newFlowPose);
      _searchQuery = '';
    });
  }

  Future<void> _saveFlow() async {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;

    final updatedFlow = widget.flow.copyWith(poses: poses);

    context.read<FlowsCubit>().updateFlowPoses(poses);
    await context.read<FlowsCubit>().saveFlowPoses(user.user.token);
    await context.read<FlowsCubit>().getAllFlows(token: user.user.token);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving flow...')),
    );

    // Save completed
    Navigator.pop(context); // pop FlowPoseEdit → returns to FlowView
    // Navigator.pop(context); // pop FlowView → back to FlowLibrary

    // Then push FlowView again (fresh)
    Navigator.push(context, FlowViewPage.route(updatedFlow));
  }



  @override
  Widget build(BuildContext context) {
    return BlocListener<FlowsCubit, FlowsState>(
      listener: (context, state) {
        if (state is EditFlowState && state.saveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flow saved successfully!')),
          );
          Navigator.pop(context); // Optionally go back to previous screen
        }
        if (state is EditFlowState && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving flow: ${state.errorMessage}')),
          );
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Add & Edit Poses'),
        actions: [
          BlocBuilder<FlowsCubit, FlowsState>(
            builder: (context, state) {
              if (state is EditFlowState && state.isSaving) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                );
              }
              // print(state);
              return IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveFlow,
              );
            },
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
            }

            // final filteredPoses = availablePoses.where((pose) {
            //   return pose.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
            //       !poses.any((flowPose) => flowPose.pose.id == pose.id); // don't show already added
            // }).toList();
            // TODO Add filtering by apparatus. maybe level

            return Column(
              children: [

                // TODO allow multiselect from pose library

                /// Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: PoseSearchBarWidget(
                    onSearchChanged: _updateSearchQuery,
                    suggestionList: availablePoses,
                    onSuggestionTapped: _addPoseToFlow,
                    hintText: 'Add new pose',
                  ),
                ),

                if (_showSwipeHint)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.swipe, size: 20, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          'Swipe left to remove a pose',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                // const SizedBox(height: 10),

                // TODO light bulb on right side of each one that opens the list of poses you can transition to from the current pose (icon only shows up if there are known transitions). if clicked it drops down and creates a horizontal sliding list of images and names.
                Expanded(
                  child: ReorderableListView(
                    padding: const EdgeInsets.only(bottom: 75), // To avoid FAB overlap
                    children: poses.map((flowPose) {
                      return Dismissible(
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
                            _showSwipeHint = false; // 👈 hide hint
                            for (int i = 0; i < poses.length; i++) {
                              poses[i] = poses[i].copyWith(poseOrder: i);
                            }
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${removedPose.pose.name} removed'),
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


                        child: ListCard(
                          title: flowPose.pose.name,
                          subtitle: 'Level ${flowPose.pose.level} | ${flowPose.pose.apparatus}',
                          imageUrl: '/${flowPose.pose.primaryMediaPath}',
                          onTapFunction: () {
                            Navigator.push(context, PoseViewPage.route(flowPose.pose));
                          },
                          // trailing: ReorderableDelayedDragStartListener(
                          //   index: poses.indexOf(flowPose),
                          //   child: const Icon(Icons.drag_indicator),
                          // ),
                        ),
                      );
                    }).toList(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = poses.removeAt(oldIndex);
                        poses.insert(newIndex, item);

                        _showSwipeHint = false; // 👈 hide hint

                        for (int i = 0; i < poses.length; i++) {
                          poses[i] = poses[i].copyWith(poseOrder: i);
                        }
                      });
                    },
                  )

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
    ),
  );
  }
}
