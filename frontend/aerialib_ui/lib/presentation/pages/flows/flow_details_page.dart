import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/flow_pose_entity.dart';

class FlowDetailPage extends StatelessWidget {
  final FlowEntity flow;

  const FlowDetailPage({Key? key, required this.flow}) : super(key: key);

  static MaterialPageRoute route(FlowEntity flow) {
    return MaterialPageRoute(
      builder: (context) => FlowDetailPage(flow: flow),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(flow.name),
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
                pose.primaryImageUrl.isNotEmpty
                    ? pose.primaryImageUrl
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
