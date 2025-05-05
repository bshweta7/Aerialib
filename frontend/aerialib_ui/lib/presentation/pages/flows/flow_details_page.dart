import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/flow_entity.dart';

import 'flow_edit_page.dart';
import 'flow_edit_poses_page.dart';

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
              Navigator.push(context, FlowEditDetailsPage.route(flow));
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



/*
import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/presentation/widgets/media_display/formatted_cached_network_image.dart';

class FlowDetailsPage extends StatelessWidget {
  final FlowEntity flow;

  const FlowDetailsPage({super.key, required this.flow});

  static MaterialPageRoute route(FlowEntity flow) => MaterialPageRoute(
    builder: (context) => FlowDetailsPage(flow: flow),
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(flow.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit page when it's implemented
            },
            tooltip: 'Edit this flow',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Apparatus:", flow.apparatus),
            _infoRow("Level:", "Level ${flow.level}"),
            const Divider(),
            _infoRow("Description:", flow.description),
            _infoRow("Teaching Cues:", flow.teachingCues),
            _infoRow("Safety Cues:", flow.safetyCues),
            _infoRow("Progressions:", flow.progressions),
            // TODO
            // _infoRow("Category:", flow.category),
            // _infoRow("Difficulty:", flow.difficulty),
            // _infoRow("Description:", flow.description),
            // _infoRow("Notes:", flow.notes),
            // _infoRow("Created By:", flow.creatorName),
            // _infoRow("Created On:", flow.createdAt != null ? _formatDate(flow.createdAt!) : null),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : 'None',
              style: TextStyle(
                fontStyle: value?.isNotEmpty == true
                    ? FontStyle.normal
                    : FontStyle.italic,
                color: value?.isNotEmpty == true ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}

 */