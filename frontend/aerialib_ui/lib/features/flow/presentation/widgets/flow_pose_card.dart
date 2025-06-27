import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/flow/domain/entities/flow_pose_entity.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';

import '../../../../shared/helpers/conversions.dart';
import '../../../../shared/helpers/formatters.dart';
import '../../../../shared/widgets/media_display/general/formatted_cached_network_image.dart';
import '../../../../shared/widgets/media_display/multi_card_view/horizontal_scroll_gallery.dart';
import '../../../pose/presentation/cubit/poses_cubit.dart';
import '../../../pose/presentation/pages/pose_view_sheet.dart';
import '../../../pose/presentation/widgets/pose_search_bar.dart';
import '../../../transitions/domain/transition_entity.dart';
import '../../../transitions/presentation/cubit/transition_cubit.dart';

class FlowPoseCard extends StatefulWidget {
  const FlowPoseCard({
    required this.flowPose,
    required this.suggestionList,
    required this.onSuggestionTapped,

    super.key
  });

  final FlowPoseEntity flowPose;
  final List<PoseEntity> suggestionList;
  final Function(int index, PoseEntity pose)? onSuggestionTapped;

  @override
  State<FlowPoseCard> createState() => _FlowPoseCardState();
}

class _FlowPoseCardState extends State<FlowPoseCard> {

  bool _isFromExpanded = false;
  bool _isToExpanded = false;
  String _searchQuery = '';

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  /// On tapped, close the card and add the pose
  void _handleSuggestionTapped(PoseEntity pose, int index,
      {required bool fromTop}) {
    widget.onSuggestionTapped?.call(index, pose);
    setState(() {
      if (fromTop) {
        _isFromExpanded = false;
      } else {
        _isToExpanded = false;
      }
    });
  }


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
            _expandedSection(
              isIncoming: true,
            ),
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
                          'Level ${pose.level} | ${capitalizeFirstLetter(pose
                              .apparatus)}',
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
                        icon: Icon(
                            _isFromExpanded ? Icons.keyboard_arrow_down : Icons
                                .keyboard_arrow_up),
                        tooltip: _isFromExpanded ? 'Collapse box' : 'Add new pose before this pose',
                        onPressed: () {
                          setState(() {
                            _isFromExpanded = !_isFromExpanded;
                          });
                        },
                      ),

                      // Next Pose Options
                      IconButton(
                        icon: Icon(
                            _isToExpanded ? Icons.keyboard_arrow_up : Icons
                                .keyboard_arrow_down),
                        tooltip: _isToExpanded ? 'Collapse box' : 'Add new pose after this pose',
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
            _expandedSection(
              isIncoming: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _expandedSection({required bool isIncoming}) {
    final poseLocation = widget.flowPose.poseOrder;
    final insertIndex = isIncoming ? poseLocation : poseLocation + 1;

    return Container(
      color: Colors.grey.shade300,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [

          // Suggested poses from transitions
          _suggestedPoseSlider(
            isIncoming: isIncoming,
            index: insertIndex,
            onSuggestionTapped: (pose, index) =>
                _handleSuggestionTapped(pose, index, fromTop: isIncoming),
          ),

          // Pose search bar
          PoseSearchBarWidget(
            onSearchChanged: _updateSearchQuery,
            suggestionList: widget.suggestionList,
            onSuggestionTapped: (pose) =>
                _handleSuggestionTapped(pose, insertIndex, fromTop: isIncoming),
            hintText: 'Add new pose',
          ),
        ],
      ),
    );
  }

  Widget _suggestedPoseSlider({
    required bool isIncoming,
    required int index,
    required Function (PoseEntity pose, int index)? onSuggestionTapped,
  }) {
    final pose = widget.flowPose.pose;

    // TODO there must be a cleaner way than to call the cubits...
    final transitionsCubit = context.read<TransitionCubit>();
    final posesCubit = context.read<PosesCubit>();

    return FutureBuilder<List<TransitionEntity>>(
        future: isIncoming
            ? transitionsCubit.getIncomingTransitionsForPose(pose.id)
            : transitionsCubit.getOutgoingTransitionsForPose(pose.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error loading transitions: ${snapshot.error}');
          } else {
            final transitions = snapshot.data ?? [];

            final mediaIcons = flowPageTransitionPosesToMediaIcons(
              transitions: transitions,
              poseMap: { for (final p in posesCubit.poses) p.id: p},
              onTap: (pose, index) => onSuggestionTapped?.call(pose, index),
              isIncoming: isIncoming,
              index: index,
            );

            if (mediaIcons.isEmpty) return const SizedBox();

            return HorizontalScrollGallery(
              mediaList: mediaIcons,
              height: 175,
              // isTextVisible: false,
            );
          }
        }
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

