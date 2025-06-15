import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/shared/widgets/info_display/expandable_card.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
import 'package:frontend/shared/widgets/media_display/cards/transition_gallery_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/helpers/conversions.dart';
import '../../../../shared/widgets/info_display/info_chip.dart';
import '../../../../shared/widgets/info_display/info_row.dart';
import '../../../../shared/widgets/media_display/general/media_icon_entity.dart';
import '../../../../shared/widgets/media_display/multi_card_view/horizontal_scroll_gallery.dart';
import '../../../transitions/presentation/cubit/transition_cubit.dart';
import '../cubit/poses_cubit.dart';


class PoseViewPage extends StatelessWidget {
  final PoseEntity pose;

  const PoseViewPage({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // TODO will show other media items too
    final mediaIcons = [
      MediaIconEntity(
        imageUrl: "/${pose.primaryMediaPath}",
        type: MediaType.pose,
        data: pose,
      )
    ];

    final posesCubit = context.read<PosesCubit>();
    final transitionsCubit = context.read<TransitionCubit>();

    return MainScaffold(
      currentIndex: 2,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Pose Details") ,  // overflow: TextOverflow.ellipsis,),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.goNamed(
                'pose-edit',
                pathParameters: {'poseId': pose.id},
                queryParameters: {'from': 'pose-view'},
              );
            },
            tooltip: 'Edit this pose',
          ),
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// Title and subtitle
            Text(
              pose.displayName,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            if (pose.altName != null && pose.altName!.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                pose.altName!,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],

            const SizedBox(height: 12),

            /// Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                InfoChip(
                  label: pose.apparatus,
                  tooltipMessage: 'Apparatus',
                ),
                InfoChip(
                  label: pose.level != null ? 'Level ${pose.level}' : null,
                  tooltipMessage: 'Level at Uplift Aerial Arts',
                ),
                InfoChip(
                  label: pose.poseType,
                  tooltipMessage: 'Type of Pose (Static or Dynamic)',
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Media preview
            SizedBox(
              width: screenHeight * 0.4,
              child: HorizontalScrollGallery(
                height: screenHeight * 0.4,
                mediaList: mediaIcons,
                itemsPerPage: 1,
                isFullWidth: true,
              ),
            ),

            const SizedBox(height: 20),

            /// Incoming Poses

                    // onTap: (transition) {
                    //   showModalBottomSheet(
                    //     context: context,
                    //     builder: (_) => TransitionDetailSheet(transition: transition),
                    //   );
                    // },
            TransitionGalleryCard(
                poseId: pose.id,
                height: screenHeight * 0.2,
                title: 'Poses To ${pose.displayName}',
                onTap: (transition) {
                  context.goNamed(
                    'transition-view',
                    pathParameters: {'transitionId': transition.id},
                    queryParameters: {'from': 'pose-view'},
                  ); // TODO when you click back from transition, it goes to pose library
                }, isIncoming: true,
            ),

            /// Outgoing Poses (poses after)
            TransitionGalleryCard(
                poseId: pose.id,
                height: screenHeight * 0.2,
                title: 'Poses From ${pose.displayName}',
                onTap: (transition) {
                  context.goNamed(
                    'transition-view',
                    pathParameters: {'transitionId': transition.id},
                    queryParameters: {'from': 'pose-view'},
                  ); // TODO when you click back from transition, it goes to pose library
                },
                isIncoming: false,
            ),

            /// Details
            ExpandableCard(
              title: "Details",
              initiallyExpanded: false,
              children: [
                InfoRow("Description:", pose.description),
                InfoRow("Teaching Cues:", pose.teachingCues),
                InfoRow("Safety Cues:", pose.safetyCues),
                InfoRow("Progressions:", pose.progressions),
                InfoRow("Modifications:", pose.modifications),
                InfoRow("Common Errors:", pose.commonErrors),
              ],
            ),

            /// Advanced Tagging
            ExpandableCard(
              title: "Advanced Tagging",
              initiallyExpanded: false,
              children: [
                InfoRow("Prefix:", pose.prefix),
                InfoRow("Base Name:", pose.baseName),
                InfoRow("Suffix:", pose.suffix),
                InfoRow("Hand Position:", pose.handPosition),
                InfoRow("Leg Position:", pose.legPosition),
                InfoRow("Position in Hoop:", pose.positionInBar),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
