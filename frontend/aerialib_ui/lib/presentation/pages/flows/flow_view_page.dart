import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/flow_entity.dart';
import 'package:frontend/domain/entities/media_icon_entity.dart';
import 'package:frontend/presentation/pages/flows/flow_details_sheet.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_details_page.dart';
import 'package:frontend/presentation/pages/flows/flow_edit_poses_page.dart';
import 'package:frontend/presentation/pages/poses/pose_view_page.dart';
import 'package:frontend/presentation/widgets/media_display/media_list/media_list.dart';
import 'package:frontend/core/utils/conversions.dart';

import '../../widgets/functional_buttons/scroll_to_top.dart';

class FlowViewPage extends StatefulWidget {
  final FlowEntity flow;

  const FlowViewPage({super.key, required this.flow});

  static MaterialPageRoute route(FlowEntity flow) {
    return MaterialPageRoute(
      builder: (context) => FlowViewPage(flow: flow),
    );
  }

  @override
  State<FlowViewPage> createState() => _FlowViewPageState();
}

class _FlowViewPageState extends State<FlowViewPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToPosePage(BuildContext context, MediaIconEntity mediaItem) {
    Navigator.push(
      context,
      PoseViewPage.route(mediaItem.data),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flow = widget.flow;
    print("[FlowViewPage] Flow ID: ${flow.id}, Name: ${flow.name}");
    print("[FlowViewPage] Thumbnail: ${flow.thumbnailImagePath}");
    print("[FlowViewPage] Pose count: ${flow.poses.length}");

    final poses = (flow.poses ?? []).map((fp) => fp.pose).toList();

    print("[FlowViewPage] Pose names: ${poses.map((p) => p.name).toList()}");
    print("[FlowViewPage] Pose image paths: ${poses.map((p) => p.primaryMediaPath).toList()}");

    final mediaItems = posesToMediaIcons(poses);

    return Scaffold(
      appBar: AppBar(
        title: Text("Flow Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'View flow details',
            onPressed: () {
              FlowDetailsSheet.show(
                context: context,
                flow: flow,
                onEdit: () {
                  Navigator.pop(context); // close bottom sheet
                  Navigator.push(context, FlowEditDetailsPage.route(flow));
                },
              );
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          mediaItems.isEmpty
              ? const Center(child: Text('No poses in this flow yet.'))
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      bottom: 400.0, // 💡 Add enough space so FABs don’t float up
                    ),
                    child: Column(
                      children: [
                        // Center(
                        //   child: Text(
                        //       flow.name,
                        //       style: const TextStyle(
                        //         fontSize: 24,
                        //         fontWeight: FontWeight.bold,
                        //       )
                        //   ),
                        // ),

                        // const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8, // or any height that fits your design
                          child: MediaList(
                            mediaItems: mediaItems,
                            onMediaTap: (item) => _navigateToPosePage(context, item),
                          ),
                        ),
                        const SizedBox(height: 10),

                      ],
                    ),
                  ),
                ),

          ScrollToTopButton(scrollController: _scrollController), // Add the button

          // Edit button (bottom left)
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton.extended(
              heroTag: 'editFAB',
              tooltip: 'Edit Poses in Flow',
              onPressed: () {
                Navigator.push(context, FlowEditPosesPage.route(flow));
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit"),
            )

          ),

          // Edit button (bottom left)
          // Positioned(
          //   bottom: 20,
          //   left: 20,
          //   child: FloatingActionButton(
          //     heroTag: 'editFAB',
          //     tooltip: 'Add, remove, or reorder poses in this flow',
          //     child: const Icon(Icons.edit),
          //     onPressed: () {
          //       Navigator.push(context, FlowEditPosesPage.route(flow));
          //     },
          //   ),
          // ),

        ],
      ),
    );
  }
}