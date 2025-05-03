import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/flow_entity.dart';

import 'flow_edit_page.dart';

class FlowDetailsPage extends StatelessWidget {
  final FlowEntity flow;

  const FlowDetailsPage({Key? key, required this.flow}) : super(key: key);

  static MaterialPageRoute route(FlowEntity flow) {
    return MaterialPageRoute(
      builder: (context) => FlowDetailsPage(flow: flow),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(flow.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, EditFlowPage.route(flow));
            },
            tooltip: 'Edit this flow',
          ),
          ]
      ),
      body: flow.poses.isEmpty
          ? const Center(child: Text('No poses in this flow yet.'))
          : ListView.builder(
        itemCount: flow.poses.length,
        itemBuilder: (context, index) {
          final flowPose = flow.poses[index];
          final pose = flowPose.pose;


          // TODO REPLACE THIS WITH REAL LIST CARD WIDGET!!!
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.network(
                pose.primaryMediaPath.isNotEmpty
                    ? pose.primaryMediaPath
                    : 'https://via.placeholder.com/100', // fallback image
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(pose.name),
              subtitle: Text(
                  'Level ${pose.level} | ${pose.apparatus}'), // You can customize this
              onTap: () {
                // TODO: Optionally navigate to Pose Details Page
                print('Tapped on pose: ${pose.name}');
              },
            ),
          );
        },
      ),
    );
  }
}
