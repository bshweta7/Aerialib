import 'package:flutter/material.dart';
import 'package:frontend/features/flow/domain/entities/flow_pose_entity.dart';

import '../../../../shared/helpers/formatters.dart';
import '../../../../shared/widgets/media_display/general/formatted_cached_network_image.dart';
import '../../../pose/presentation/pages/pose_view_sheet.dart';

class FlowPoseCard extends StatefulWidget {
  const FlowPoseCard({
    required this.flowPose,
    required this.searchBarBuilder,
    super.key
  });

  final FlowPoseEntity flowPose;
  final Widget Function(BuildContext context, int index) searchBarBuilder;

  @override
  State<FlowPoseCard> createState() => _FlowPoseCardState();
}

class _FlowPoseCardState extends State<FlowPoseCard> {
  bool _isNextExpanded = false;

  @override
  Widget build(BuildContext context) {
    final pose = widget.flowPose.pose;

    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              PoseViewSheet.show(context: context, pose: pose);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  // Drag handle
                  Icon(Icons.drag_handle, color: Colors.grey),

                  const SizedBox(width: 8.0),

                  // Image
                  SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FormattedCachedNetworkImage(pose.primaryMediaPath),
                    ),
                  ),
                  const SizedBox(width: 16.0),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          pose.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Level ${pose.level} | ${capitalizeFirstLetter(pose.apparatus)}',
                          style: const TextStyle(fontSize: 14.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  
                  // Next Pose Options
                  IconButton(
                    icon: Icon(_isNextExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    tooltip: 'Add new pose after this pose',
                    onPressed: () {
                      setState(() {
                        _isNextExpanded = !_isNextExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          if (_isNextExpanded) ...[
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Suggested next poses:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      // Replace with actual pose suggestions
                      CircleAvatar(radius: 24, child: Icon(Icons.fitness_center)),
                      CircleAvatar(radius: 24, child: Icon(Icons.fitness_center)),
                      CircleAvatar(radius: 24, child: Icon(Icons.fitness_center)),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  widget.searchBarBuilder(context, widget.flowPose.poseOrder + 1),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}


                  // TODO Use favorite logic for "locking" poses
                  // if (isFavorite != null)
                  //   IconButton(
                  //     icon: Icon(
                  //       isFavorite! ? Icons.favorite : Icons.favorite_border,
                  //       color: isFavorite! ? Colors.red : Colors.grey,
                  //     ),
                  //     onPressed: onFavoriteToggle,
                  //   )
                  // else if (trailing != null)
                  //   trailing!,
