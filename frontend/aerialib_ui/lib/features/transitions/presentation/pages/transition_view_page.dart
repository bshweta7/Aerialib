import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/transitions/domain/transition_entity.dart';
import 'package:frontend/shared/widgets/info_display/info_row.dart';
import 'package:frontend/shared/widgets/media_display/general/media_icon_entity.dart';

import '../../../../shared/features/navigation/widgets/smart_back_button.dart';
import '../../../../shared/widgets/info_display/expandable_card.dart';
import '../../../../shared/widgets/info_display/info_chip.dart';
import '../../../../shared/widgets/main_scaffold.dart';
import '../../../../shared/widgets/media_display/general/formatted_image.dart';
import '../../../../shared/widgets/media_display/multi_card_view/horizontal_scroll_gallery.dart';
import '../../../pose/presentation/cubit/poses_cubit.dart';


// TODO would this be better as a modal?

class TransitionViewPage extends StatelessWidget {
  final TransitionEntity transition;

  const TransitionViewPage({super.key, required this.transition});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final posesCubit = context.read<PosesCubit>();
    final fromPose = posesCubit.poses.firstWhere(
      (p) => p.id == transition.fromPoseId,
    );
    final toPose = posesCubit.poses.firstWhere(
      (p) => p.id == transition.toPoseId,
    );
    log(fromPose.primaryMediaPath);

    final mediaIcons = [
      MediaIconEntity(
        imageUrl: "/${transition.primaryMediaPath}",
        type: MediaType.transition,
        data: transition,
      ),
    ];

    return MainScaffold(
      currentIndex: 2,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Transition Details") ,  // overflow: TextOverflow.ellipsis,),
        // TODO enable transition editing
        //  actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () {
        //       context.goNamed(
        //         'transition-edit',
        //         pathParameters: {'transitionId': transition.id},
        //         queryParameters: {'from': 'transition-view'},
        //       );
        //     },
        //     tooltip: 'Edit this transition',
        //   ),
        // ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// Title and subtitle
            Text(
              transition.name == null ? "Transition" : transition.name!,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            Text(
              "From ${fromPose.displayName}\nTo ${toPose.displayName}",
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),



            /// Media preview
            if (transition.primaryMediaPath != null && transition.primaryMediaPath!.trim().isNotEmpty)
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


            /// From -> To Pose Row
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
            const SizedBox(height: 24),

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
                InfoChip(
                  label: transition.level != null ? 'Level ${transition.level}' : null,
                  tooltipMessage: 'Level at Uplift Aerial Arts',
                ),
                InfoChip(
                  label: transition.transitionType,
                  tooltipMessage: 'Type of Transition (Mount/Dismount, Roll, Drop)',
                ),
              ],
            ),



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
          ],
        ),
      ),
    );
  }

  Widget _posePreview(String mediaUrl, double width) {
    return Column(
      children: [
        SizedBox(
          width: width,
          height: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FormattedImage(mediaUrl)
          ),
        ),
        // const SizedBox(height: 4),
        // Text(
        //   pose.displayName,
        //   style: const TextStyle(fontSize: 12),
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }
}
