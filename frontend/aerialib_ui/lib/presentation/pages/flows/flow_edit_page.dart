import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/flow_pose_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/pose_entity.dart';

class FlowEditPage extends StatefulWidget {
  final FlowEntity flow;

  const FlowEditPage({super.key, required this.flow});

  static MaterialPageRoute route(FlowEntity flow) {
    return MaterialPageRoute(
      builder: (context) => FlowEditPage(flow: flow),
    );
  }

  @override
  State<FlowEditPage> createState() => _FlowEditPageState();
}

class _FlowEditPageState extends State<FlowEditPage> {
  late List<FlowPoseEntity> poses;

  @override
  void initState() {
    super.initState();
    poses = List.from(widget.flow.poses); // Copy current poses
  }

  void _addDummyPose() {
    final newPose = FlowPoseEntity(
      id: const Uuid().v4(),
      flowId: widget.flow.id,
      pose: dummyPose(), // We'll make a dummy pose for now
      poseOrder: poses.length,
    );

    setState(() {
      poses.add(newPose);
    });
  }

  void _saveFlow() {
    // TODO: Update flow pose order and save back to database
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
        title: const Text('Edit Flow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveFlow,
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _addDummyPose,
            child: const Text('Add Pose (for now)'),
          ),
          Expanded(
            child: ReorderableListView(
              children: poses.map((flowPose) {
                return ListTile(
                  key: ValueKey(flowPose.id),
                  title: Text(flowPose.pose.name),
                  subtitle: Text('Level ${flowPose.pose.level} | ${flowPose.pose.apparatus}'),
                  leading: const Icon(Icons.drag_handle),
                );
              }).toList(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = poses.removeAt(oldIndex);
                  poses.insert(newIndex, item);

                  // Update poseOrder after reordering
                  for (int i = 0; i < poses.length; i++) {
                    poses[i] = poses[i].copyWith(poseOrder: i);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Dummy pose generator (temporary until real pose picker)
  PoseEntity dummyPose() {
    return PoseEntity(
      id: const Uuid().v4(),
      name: 'Dummy Pose ${poses.length + 1}',
      description: 'Just a placeholder',
      cues: 'Cues go here',
      apparatus: 'Hoop',
      level: 1,
      createdBy: 'system',
      updatedBy: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: 0,
      primaryImageId: '',
      primaryImageUrl: '',
    );
  }
}
