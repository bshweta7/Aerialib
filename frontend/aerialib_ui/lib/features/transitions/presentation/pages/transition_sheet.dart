import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/features/user/presentation/cubit/auth_cubit.dart';

import '../../../../shared/widgets/info_display/expandable_card.dart';
import '../../../../shared/widgets/info_display/info_chip.dart';
import '../../../../shared/widgets/info_display/info_row.dart';
import '../../../../shared/widgets/media_display/general/formatted_image.dart';
import '../../../../shared/widgets/media_display/general/media_icon_entity.dart';
import '../../../../shared/widgets/media_display/multi_card_view/horizontal_scroll_gallery.dart';
import '../../../pose/domain/entities/pose_entity.dart';
import '../../domain/transition_entity.dart';


class TransitionSheet extends StatelessWidget {
  final TransitionEntity transition;
  final PoseEntity fromPose;
  final PoseEntity toPose;
  final VoidCallback? onEdit;

  const TransitionSheet({
    super.key,
    required this.transition,
    required this.fromPose,
    required this.toPose,
    this.onEdit,
  });

  static Future<void> show({
    required BuildContext context,
    required TransitionEntity transition,
    required PoseEntity fromPose,
    required PoseEntity toPose,
    VoidCallback? onEdit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.25,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: TransitionSheet(
                  transition: transition,
                  fromPose: fromPose,
                  toPose: toPose,
                  onEdit: onEdit,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final mediaIcons = [
      MediaIconEntity(
        imageUrl: "/${transition.primaryMediaPath}",
        type: MediaType.transition,
        data: transition,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Drag handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        /// Title
        Text(
          transition.name ?? "Transition",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),

        /// Subtitle
        Text(
          "From ${fromPose.displayName}\nTo ${toPose.displayName}",
          style: Theme.of(context).textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        /// Media preview
        if (transition.primaryMediaPath != null && transition.primaryMediaPath!.isNotEmpty)
          SizedBox(
            width: screenHeight * 0.4,
            child: HorizontalScrollGallery(
              height: screenHeight * 0.4,
              mediaList: mediaIcons,
              itemsPerPage: 1,
              isFullWidth: true,
            ),
          ),
        const SizedBox(height: 16),

        /// Pose image row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _posePreview(fromPose.primaryMediaPath, screenWidth * 0.3),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.arrow_forward, size: 28),
            ),
            _posePreview(toPose.primaryMediaPath, screenWidth * 0.3),
          ],
        ),

        const SizedBox(height: 20),

        /// Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            InfoChip(
              label: transition.apparatus,
              tooltipMessage: 'Apparatus',
            ),
            if (transition.level != null)
              InfoChip(
                label: 'Level ${transition.level}',
                tooltipMessage: 'Level at Uplift Aerial Arts',
              ),
            if (transition.transitionType != null)
              InfoChip(
                label: transition.transitionType,
                tooltipMessage: 'Type of Transition (Mount/Dismount, Roll, Drop)',
              ),
          ],
        ),

        const SizedBox(height: 16),

        /// Details
        ExpandableCard(
          title: "Details",
          children: [
            InfoRow("Description:", transition.description),
            InfoRow("Teaching Cues:", transition.teachingCues),
            InfoRow("Safety Cues:", transition.safetyCues),
            InfoRow("Progressions:", transition.progressions),
            InfoRow("Modifications:", transition.modifications),
            InfoRow("Common Errors:", transition.commonErrors),
          ],
        ),

        const SizedBox(height: 24),

        if (onEdit != null)
          ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: const Text("Edit Transition Details"),
          ),
      ],
    );
  }

  Widget _posePreview(String mediaUrl, double width) {
    return SizedBox(
      width: width,
      height: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FormattedImage(mediaUrl),
      ),
    );
  }
}
