import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/flow_pose_entity.dart';
import 'package:frontend/domain/entities/pose_entity.dart';

import 'package:frontend/presentation/cubit/flows/flows_cubit.dart';
import 'package:frontend/presentation/widgets/search_bars/pose_search_bar.dart';

import '../../widgets/media_display/media_list/list_card.dart';
import '../poses/pose_details_page.dart';

class EditFlowPage extends StatefulWidget {
  final FlowEntity flow;

  const EditFlowPage({super.key, required this.flow});

  static MaterialPageRoute route(FlowEntity flow) {
    return MaterialPageRoute(
      builder: (context) => EditFlowPage(flow: flow),
    );
  }

  @override
  State<EditFlowPage> createState() => _EditFlowPageState();
}

class _EditFlowPageState extends State<EditFlowPage> {
  late List<FlowPoseEntity> poses;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    poses = List.from(widget.flow.poses);

    // Load all poses for searching
    context.read<FlowsCubit>().fetchAllAvailablePoses();
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

  void _saveFlow() {
    // TODO: Save pose order and sync to backend
    print('Saving flow with ${poses.length} poses');
    for (var pose in poses) {
      print('Pose: ${pose.pose.name}');
    }
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add & Edit Poses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveFlow,
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

          if (state is AvailablePosesLoaded) {
            final availablePoses = state.poses;

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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SearchBarWidget(
                    onSearchChanged: _updateSearchQuery,
                    suggestionList: availablePoses,
                    onSuggestionTapped: _addPoseToFlow,
                  ),
                ),

                const SizedBox(height: 10),

                // TODO light bulb on right side of each one that opens the list of poses you can transition to from the current pose (icon only shows up if there are known transitions). if clicked it drops down and creates a horizontal sliding list of images and names.
                Expanded(
                  child: ReorderableListView(
                    children: poses.map((flowPose) {
                      return ReorderableDragStartListener(
                        key: ValueKey(flowPose.id), // key goes here ✨
                        index: poses.indexOf(flowPose),
                        child: ListCard(
                          key: ValueKey(flowPose.id),
                          title: flowPose.pose.name,
                          subtitle: 'Level ${flowPose.pose.level} | ${flowPose.pose.apparatus}',
                          imageUrl: flowPose.pose.primaryImageUrl ?? '', // fallback if needed
                          onTapFunction: () {
                            Navigator.push(
                              context,
                              PoseDetailsPage.route(flowPose.pose),
                            );
                          },
                          trailing: ReorderableDragStartListener(
                            index: poses.indexOf(flowPose),
                            child: const Icon(Icons.drag_handle),
                          ),
                        )

                      );

                    }).toList(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = poses.removeAt(oldIndex);
                        poses.insert(newIndex, item);

                        for (int i = 0; i < poses.length; i++) {
                          poses[i] = poses[i].copyWith(poseOrder: i);
                        }
                      });
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox(); // fallback
        },
      ),
    );
  }
}
