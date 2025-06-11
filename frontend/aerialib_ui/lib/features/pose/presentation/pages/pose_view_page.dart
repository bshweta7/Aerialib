import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/shared/widgets/info_display/expandable_card.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
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
      )
    ];

    final posesCubit = context.read<PosesCubit>();
    final transitionsCubit = context.read<TransitionCubit>();

    final poseMap = {
      for (final p in posesCubit.poses) p.id: p
    };

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
            FutureBuilder(
              future: transitionsCubit.getIncomingTransitionsForPose(pose.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading transitions: ${snapshot.error}');
                } else {
                  final incoming = snapshot.data ?? [];

                    final fromPoses = incoming
                        .map((t) => poseMap[t.fromPoseId])
                        .whereType<PoseEntity>()
                        .toList();

                    final mediaIcons = posesToMediaIcons(fromPoses);

                    return ExpandableCard(
                      title: 'Incoming Poses',
                      children: [
                        HorizontalScrollGallery(
                          mediaList: mediaIcons,
                          height: screenHeight * 0.2,
                        ),
                      ]
                    );
                  //
                  //
                  //   return MediaGridCard(
                  //     caption: fromPose.displayName,
                  //     mediaUrl: fromPose.primaryMediaPath,
                  //     onTapFunction: () {
                  //       // TODO: open transition modal
                  //     },
                  //   );
                  // }).whereType<Widget>().toList();
                  //
                  // return ExpandableCard(
                  //   title: "Incoming Poses",
                  //   children: [
                  //     GridView.count(
                  //       shrinkWrap: true,
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       crossAxisCount: 2,
                  //       childAspectRatio: 0.85,
                  //       children: cards,
                  //     )
                  //   ],
                  // );
                }
              },
            ),

            /// Teaching Notes
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
