import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/flow_entity.dart';

import 'flow_details_sheet.dart';
import 'flow_edit_details_page.dart';
import 'flow_edit_poses_page.dart';

class FlowViewPage extends StatelessWidget {
  final FlowEntity flow;

  const FlowViewPage({super.key, required this.flow});

  static MaterialPageRoute route(FlowEntity flow) {
    return MaterialPageRoute(
      builder: (context) => FlowViewPage(flow: flow),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(flow.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'View flow details',
            onPressed: () {
              FlowDetailsSheet.show(
                context: context,
                flow: flow,
                onEdit: () {
                  Navigator.pop(context); // Close bottom sheet first
                  Navigator.push(context, FlowEditDetailsPage.route(flow));
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, FlowEditPosesPage.route(flow));
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Poses'),
        tooltip: 'Add poses to this flow',
      ),
      body: flow.poses.isEmpty
          ? const Center(child: Text('No poses in this flow yet.'))
          : ListView.builder(
        itemCount: flow.poses.length,
        itemBuilder: (context, index) {
          final flowPose = flow.poses[index];
          final pose = flowPose.pose;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.network(
                pose.primaryMediaPath.isNotEmpty
                    ? pose.primaryMediaPath
                    : 'https://via.placeholder.com/100',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(pose.name),
              subtitle: Text('Level ${pose.level} | ${pose.apparatus}'),
              onTap: () {
                // Optional: Navigate to pose details
              },
            ),
          );
        },
      ),
    );
  }
}
