import 'package:flutter/material.dart';
import 'package:frontend/core/utils/formatters.dart';
import 'package:frontend/domain/entities/pose_entity.dart';
import 'package:frontend/presentation/widgets/media_display/formatted_cached_network_image.dart';
import 'package:frontend/presentation/widgets/main_scaffold.dart';


class PoseViewPage extends StatefulWidget {
  final PoseEntity pose;

  const PoseViewPage({super.key, required this.pose});

  @override
  State<PoseViewPage> createState() => _PoseViewPageState();
}

class _PoseViewPageState extends State<PoseViewPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final pose = widget.pose;
    // final state = context.read<PosesCubit>().state;
    // late final PoseEntity updatedPose;
    //
    // if (state is GetPosesSuccess) {
    //   updatedPose = state.poses.firstWhere((p) => p.id == widget.pose.id);
    // } else {
    //   // fallback to old pose if needed
    //   updatedPose = widget.pose;
    // }
    //
    final screenHeight = MediaQuery.of(context).size.height;

    return MainScaffold(
      currentIndex: 2,
      appBar: AppBar(
        title: Text(
          "Pose Details",
          overflow: TextOverflow.ellipsis,
        ),
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
        //   ] // TODO ADD EDITING
      ),
        // TODO Ask about ordering of items on page, ensure consistency across add, edit, and details pages
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Text(
                pose.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),

            const SizedBox(height: 10),

            // Updated: image in a rounded Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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

            _infoRow("Apparatus:", capitalizeFirstLetter(pose.apparatus)),
            _infoRow("Level:", "Level ${pose.level}"),
            const Divider(),
            _infoRow("Description:", pose.description),
            _infoRow("Teaching Cues:", pose.teachingCues),
            _infoRow("Safety Cues:", pose.safetyCues),
            _infoRow("Progressions:", pose.progressions),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.isNotEmpty == true ? value! : 'None',
              style: TextStyle(
                fontStyle: value?.isNotEmpty == true
                    ? FontStyle.normal
                    : FontStyle.italic,
                color: value?.isNotEmpty == true ? Colors.black : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
