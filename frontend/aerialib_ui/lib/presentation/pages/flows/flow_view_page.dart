import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/presentation/pages/flows/flow_details_sheet.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_details_page.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_poses_page.dart';
import 'package:frontend/presentation/pages/poses/pose_details_page.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/media_list.dart';
import 'package:frontend/core/utils/conversions.dart';

class FlowViewPage extends StatelessWidget {
  final FlowEntity flow;

  const FlowViewPage({super.key, required this.flow});

  static MaterialPageRoute route(FlowEntity flow) {
    return MaterialPageRoute(
      builder: (context) => FlowViewPage(flow: flow),
    );
  }

  void _navigateToPosePage(BuildContext context, MediaIconEntity mediaItem) {
    Navigator.push(
      context,
      PoseDetailsPage.route(mediaItem.data),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("[FlowViewPage] ${flow.poses}");
    print("[FlowViewPage] ${flow.name}");

    final mediaItems = posesToMediaIcons(flow.poses.map((fp) => fp.pose).toList());

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
                  Navigator.pop(context);
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
      body: mediaItems.isEmpty
          ? const Center(child: Text('No poses in this flow yet.'))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: MediaList(
            mediaItems: mediaItems,
            onMediaTap: (item) => _navigateToPosePage(context, item),
          ),
        ),
      ),
    );
  }
}