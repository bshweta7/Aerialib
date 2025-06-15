import 'package:flutter/material.dart';
import 'package:frontend/features/flow/domain/entities/flow_pose_entity.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';

import '../../../../shared/helpers/formatters.dart';
import '../../../../shared/widgets/media_display/cards/transition_gallery_card.dart';
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
  bool _isFromExpanded = false;
  bool _isToExpanded = false;

  @override
  Widget build(BuildContext context) {
    final pose = widget.flowPose.pose;

    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        children: [

          // Top expansion
          if (_isFromExpanded) ...[
            _ExpandedSection(
              pose: pose,
              searchBar: widget.searchBarBuilder(context, widget.flowPose.poseOrder),
              isIncoming: true,),
          ],
          
          InkWell(
            onTap: () {
              PoseViewSheet.show(context: context, pose: pose);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  // Drag handle
                  const Icon(Icons.drag_handle, color: Colors.grey),

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
                  
                  
                  // Expand Arrows
                  Column(
                    children: [
                      // From Pose Options
                      IconButton(
                        icon: Icon(_isFromExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                        tooltip: 'Add new pose before this pose',
                        onPressed: () {
                          setState(() {
                            _isFromExpanded = !_isFromExpanded;
                          });
                        },
                      ),

                      // Next Pose Options
                      IconButton(
                        icon: Icon(_isToExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                        tooltip: 'Add new pose after this pose',
                        onPressed: () {
                          setState(() {
                            _isToExpanded = !_isToExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Top expansion
          if (_isToExpanded) ...[
            _ExpandedSection(
              pose: pose,
              searchBar: widget.searchBarBuilder(context, widget.flowPose.poseOrder + 1),
              isIncoming: false,),
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



class _ExpandedSection extends StatelessWidget {
  final PoseEntity pose;
  final Widget searchBar;
  final bool isIncoming; // Incoming --> poses that result in current pose (top)

  const _ExpandedSection({
    required this.pose,
    required this.searchBar,
    required this.isIncoming
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // const SizedBox(height: 16.0),
          // const Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text("Select pose:", style: TextStyle(fontWeight: FontWeight.bold)),
          // ),
          // const SizedBox(height: 8.0),

          // TODO remove this
          TransitionGalleryCard(
            poseId: pose.id,
            height: 50,
            title: 'Poses ${isIncoming ? 'To' : 'From'} ${pose.displayName}',
            isIncoming: true,
          ),

          searchBar,
        ],
      ),
    );
  }
}
