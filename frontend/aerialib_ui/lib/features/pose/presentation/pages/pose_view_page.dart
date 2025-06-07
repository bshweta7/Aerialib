import 'package:flutter/material.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/shared/widgets/media_display/general/formatted_cached_network_image.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/widgets/info_display/info_row.dart';
import '../../../../shared/widgets/info_display/section_card.dart';
import '../../../../shared/widgets/media_display/horizontal_cover_media_gallery.dart';
import '../../../../shared/widgets/media_display/general/media_item.dart';


class PoseViewPage extends StatelessWidget {
  final PoseEntity pose;

  const PoseViewPage({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final mediaItems = [
      MediaItem(url: 'default/flow_placeholders/peach.png'),
      MediaItem(url: 'default/flow_placeholders/mint.png'),
      MediaItem(url: pose.primaryMediaPath),
      // MediaItem(url: pose.primaryMediaPath),
    ];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Center(
              child: Text(
                pose.displayName,
                style: Theme.of(context).textTheme.headlineLarge
              ),
            ),
            const SizedBox(height: 10),

            /// Media preview
            HorizontalCoverMediaGallery(mediaList: mediaItems),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.4,
                  minHeight: 20,
                ),
                width: double.infinity,
                child: FormattedCachedNetworkImage("/${pose.primaryMediaPath}"),
              ),
            ),
            const SizedBox(height: 20),

            /// Basic Info
            SectionCard( // TODO Make this take the whole page
              title: "Basic Info",
              children: [
                InfoRow("Apparatus:", capitalizeFirstLetter(pose.apparatus)),
                InfoRow("Level:", "Level ${pose.level}"),
              ],
            ),

            /// Additional Details
            SectionCard(
              title: "Additional Details",
              children: [
                InfoRow("Alternative Name:", pose.altName),
                InfoRow("Description:", pose.description),
                InfoRow("Pose Type:", pose.poseType),
              ],
            ),

            /// Notes
            SectionCard(
              title: "Notes",
              children: [
                InfoRow("Teaching Cues:", pose.teachingCues),
                InfoRow("Safety Cues:", pose.safetyCues),
                InfoRow("Progressions:", pose.progressions),
                InfoRow("Modifications:", pose.modifications),
                InfoRow("Common Errors:", pose.commonErrors),
              ],
            ),

            /// Advanced Tagging
            SectionCard(
              title: "Advanced Tagging",
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
