import 'package:flutter/material.dart';
import 'package:frontend/shared/helpers/formatters.dart';
import 'package:frontend/features/pose/domain/entities/pose_entity.dart';
import 'package:frontend/shared/features/media_display/widgets/formatted_cached_network_image.dart';
import 'package:frontend/shared/widgets/main_scaffold.dart';
import 'package:frontend/shared/features/navigation/widgets/smart_back_button.dart';

import '../../../../shared/widgets/info_row.dart';


class PoseViewPage extends StatelessWidget {
  final PoseEntity pose;

  const PoseViewPage({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return MainScaffold(
      currentIndex: 2,
      appBar: AppBar(
        leading: const SmartBackButton(),
        title: const Text("Pose Details") ,  // overflow: TextOverflow.ellipsis,),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           PoseEditDetailsPage.route(widget.pose)
        //       );
        //     },
        //     tooltip: 'Edit this pose',
        //   ),
        //   ] // TODO ADD EDITING - only allow editing if the pose was created by the user.
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
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            /// Media preview
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
            // TODO Make this a small subtitle right under the title instead of taking up two rows like "Lyra | Level 1"
            InfoRow("Apparatus:", capitalizeFirstLetter(pose.apparatus)),
            InfoRow("Level:", "Level ${pose.level}"),

            /// Details
            const Divider(),
            InfoRow("Description:", pose.description),
            InfoRow("Teaching Cues:", pose.teachingCues),
            InfoRow("Safety Cues:", pose.safetyCues),
            InfoRow("Progressions:", pose.progressions),
            InfoRow("Modifications:", pose.modifications),
            InfoRow("Common Errors:", pose.commonErrors),

            /// Positional tags
            const Divider(),
            // TODO Add a expandable card for "Advanced Tagging"
            InfoRow("Prefix:", pose.prefix),
            InfoRow("Suffix:", pose.suffix),
            InfoRow("Base Name:", pose.baseName),
            InfoRow("Hand Position:", pose.handPosition),
            InfoRow("Leg Position:", pose.legPosition),
            InfoRow("Position in Hoop:", pose.positionInBar),
            // TODO where should "alternative names" go?
          ],
        ),
      ),
    );
  }
}
